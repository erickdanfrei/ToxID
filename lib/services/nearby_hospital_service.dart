import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/hospital.dart';

class NearbyResult {
  final List<Hospital> hospitals;
  final DateTime fetchedAt;
  final bool cached;
  const NearbyResult(this.hospitals, this.fetchedAt, this.cached);
}

/// Consulta manual, com timeout e cache. Não fornece informações de soroterapia.
class NearbyHospitalService {
  static const endpoint = String.fromEnvironment(
    'OVERPASS_URL',
    defaultValue: 'https://overpass-api.de/api/interpreter',
  );
  final http.Client _client;
  NearbyHospitalService({http.Client? client})
    : _client = client ?? http.Client();
  void dispose() => _client.close();

  static List<Hospital> parseElements(List<dynamic> elements) {
    final result = <String, Hospital>{};
    for (final raw in elements) {
      if (raw is! Map) continue;
      if (raw['tags'] is! Map || raw['id'] == null || raw['type'] == null)
        continue;
      final tags = Map<String, dynamic>.from(raw['tags'] as Map);
      if (tags['amenity'] != 'hospital' && tags['healthcare'] != 'hospital')
        continue;
      final center = raw['center'] is Map ? raw['center'] as Map : raw;
      final lat = center['lat'] is num
          ? (center['lat'] as num).toDouble()
          : null;
      final lon = center['lon'] is num
          ? (center['lon'] as num).toDouble()
          : null;
      if (lat == null ||
          lon == null ||
          !lat.isFinite ||
          !lon.isFinite ||
          lat.abs() > 90 ||
          lon.abs() > 180)
        continue;
      final id = 'osm-${raw['type']}-${raw['id']}';
      result[id] = Hospital(
        id: id,
        name: (tags['name'] ?? 'Hospital sem nome no mapa').toString(),
        city: (tags['addr:city'] ?? '').toString(),
        state: (tags['addr:state'] ?? '').toString(),
        address: [
          tags['addr:street'],
          tags['addr:housenumber'],
          tags['addr:suburb'],
        ].where((v) => v != null).join(', '),
        phone: (tags['contact:phone'] ?? tags['phone'] ?? '').toString(),
        latitude: lat,
        longitude: lon,
        availableSerums: const [],
      );
    }
    return result.values.toList();
  }

  Future<NearbyResult> search(double lat, double lon, int radiusKm) async {
    if (!lat.isFinite ||
        !lon.isFinite ||
        lat.abs() > 90 ||
        lon.abs() > 180 ||
        ![5, 10, 25, 50].contains(radiusKm)) {
      throw ArgumentError('Localização ou raio inválido');
    }
    final a = lat.toStringAsFixed(3), b = lon.toStringAsFixed(3);
    final key = 'nearby-v1:$a:$b:$radiusKm';
    final prefs = await SharedPreferences.getInstance();
    NearbyResult? previous;
    try {
      final stored = prefs.getString(key);
      if (stored != null) {
        final data = jsonDecode(stored) as Map<String, dynamic>;
        previous = NearbyResult(
          (data['hospitals'] as List)
              .map((e) => Hospital.fromMap(Map<String, dynamic>.from(e as Map)))
              .toList(),
          DateTime.parse(data['at'] as String),
          true,
        );
        if (DateTime.now().difference(previous.fetchedAt) <
            const Duration(minutes: 10))
          return previous;
      }
    } catch (_) {
      /* Cache inválido não bloqueia uma consulta nova. */
    }
    try {
      final radius = radiusKm * 1000;
      final query =
          '[out:json][timeout:25];(nwr[amenity=hospital](around:$radius,$a,$b);nwr[healthcare=hospital](around:$radius,$a,$b););out center tags;';
      final response = await _client
          .post(Uri.parse(endpoint), body: {'data': query})
          .timeout(const Duration(seconds: 35));
      if (response.statusCode != 200)
        throw StateError(
          'Serviço de mapas indisponível (${response.statusCode}).',
        );
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['remark'] != null)
        throw StateError('Consulta incompleta. Tente um raio menor.');
      final hospitals = parseElements(data['elements'] as List);
      hospitals.sort(
        (x, y) => x.distanceFrom(lat, lon).compareTo(y.distanceFrom(lat, lon)),
      );
      final now = DateTime.now();
      // Mantém no máximo oito áreas de consulta, sem histórico ilimitado de locais.
      try {
        final keys = prefs
            .getKeys()
            .where((k) => k.startsWith('nearby-v1:'))
            .toList();
        if (!keys.contains(key) && keys.length >= 8)
          await prefs.remove(keys.first);
        await prefs.setString(
          key,
          jsonEncode({
            'at': now.toIso8601String(),
            'hospitals': hospitals.map((h) => h.toMap()).toList(),
          }),
        );
      } catch (_) {
        /* A falha de cache não invalida a resposta da rede. */
      }
      return NearbyResult(hospitals, now, false);
    } catch (_) {
      if (previous != null) return previous;
      rethrow;
    }
  }
}
