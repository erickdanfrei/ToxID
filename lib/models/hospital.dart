import 'dart:math';

/// Modelo de domínio que representa um Hospital ou Centro de Atendimento Antiveneno.
/// Mapeado diretamente para a coleção 'hospitais' no Cloud Firestore.
class Hospital {
  final String id;
  final String name;
  final String state;
  final String city;
  final String address;
  final String phone;
  final String emergencyPhone;
  final double latitude;
  final double longitude;
  final List<String> availableSerums;

  const Hospital({
    required this.id,
    required this.name,
    required this.state,
    required this.city,
    required this.address,
    required this.phone,
    this.emergencyPhone = '192',
    required this.latitude,
    required this.longitude,
    this.availableSerums = const [],
  });

  /// Calcula a distância em quilômetros com base na fórmula de Haversine
  double distanceFrom(double userLat, double userLng) {
    const double p = 0.017453292519943295; // Math.PI / 180
    final double a = 0.5 -
        cos((latitude - userLat) * p) / 2 +
        cos(userLat * p) *
            cos(latitude * p) *
            (1 - cos((longitude - userLng) * p)) /
            2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  /// Estima o tempo em minutos para deslocamento urbano/rodoviário (média de 50km/h)
  int estimatedMinutesFrom(double userLat, double userLng) {
    final km = distanceFrom(userLat, userLng);
    final minutes = (km / 50.0) * 60;
    return max(5, minutes.round());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'city': city,
      'address': address,
      'phone': phone,
      'emergencyPhone': emergencyPhone,
      'latitude': latitude,
      'longitude': longitude,
      'availableSerums': availableSerums,
    };
  }

  factory Hospital.fromMap(Map<String, dynamic> map, [String? docId]) {
    return Hospital(
      id: docId ?? map['id'] ?? '',
      name: map['name'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      emergencyPhone: map['emergencyPhone'] ?? '192',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      availableSerums: List<String>.from(map['availableSerums'] ?? []),
    );
  }

  Hospital copyWith({
    String? id,
    String? name,
    String? state,
    String? city,
    String? address,
    String? phone,
    String? emergencyPhone,
    double? latitude,
    double? longitude,
    List<String>? availableSerums,
  }) {
    return Hospital(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      city: city ?? this.city,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      availableSerums: availableSerums ?? this.availableSerums,
    );
  }
}
