import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class HospitalRoute {
  final List<LatLng> points;
  final double meters, seconds;
  const HospitalRoute(this.points, this.meters, this.seconds);
  static HospitalRoute parse(Map<String, dynamic> data) {
    if (data['code'] != 'Ok' ||
        data['routes'] is! List ||
        (data['routes'] as List).isEmpty) {
      throw StateError('Rota indisponível');
    }
    final r = data['routes'][0];
    final coords = r['geometry']['coordinates'] as List;
    final points = coords.map((c) {
      final lon = (c[0] as num).toDouble(), lat = (c[1] as num).toDouble();
      if (!lat.isFinite || !lon.isFinite || lat.abs() > 90 || lon.abs() > 180)
        throw StateError('Coordenada inválida');
      return LatLng(lat, lon);
    }).toList();
    final meters = (r['distance'] as num).toDouble(),
        seconds = (r['duration'] as num).toDouble();
    if (points.length < 2 ||
        !meters.isFinite ||
        !seconds.isFinite ||
        meters < 0 ||
        seconds < 0)
      throw StateError('Rota inválida');
    return HospitalRoute(points, meters, seconds);
  }
}

class HospitalRouteService {
  final http.Client _client;
  HospitalRouteService({http.Client? client})
    : _client = client ?? http.Client();
  void dispose() => _client.close();
  Future<HospitalRoute> fetch(LatLng origin, LatLng destination) async {
    const base = String.fromEnvironment(
      'ROUTING_URL',
      defaultValue: 'https://router.project-osrm.org',
    );
    final coordinates =
        '${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}';
    final uri = Uri.parse('$base/route/v1/driving/$coordinates').replace(
      queryParameters: {
        'overview': 'full',
        'geometries': 'geojson',
        'steps': 'false',
      },
    );
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 20));
    if (response.statusCode != 200)
      throw StateError('Serviço de rotas indisponível');
    return HospitalRoute.parse(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
