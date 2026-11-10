/// Modelo de Registro de Ocorrência / Identificação de Acidente.
/// Atende aos requisitos:
/// - "Implementar histórico local das identificações realizadas pelo usuário"
/// - "Registrar a localização geográfica das ocorrências utilizando GPS"
/// - "Sincronizar automaticamente os dados locais com o Firebase quando a conexão for restabelecida"
class Occurrence {
  final String id;
  final String userId;
  final String speciesId;
  final String speciesName;
  final String scientificName;
  final String dangerLevel;
  final String antivenom;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;
  final bool synced;

  const Occurrence({
    required this.id,
    this.userId = 'anonymous_user',
    required this.speciesId,
    required this.speciesName,
    required this.scientificName,
    required this.dangerLevel,
    required this.antivenom,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.synced = false,
  });

  Occurrence copyWith({
    String? id,
    String? userId,
    String? speciesId,
    String? speciesName,
    String? scientificName,
    String? dangerLevel,
    String? antivenom,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    bool? synced,
  }) {
    return Occurrence(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      speciesId: speciesId ?? this.speciesId,
      speciesName: speciesName ?? this.speciesName,
      scientificName: scientificName ?? this.scientificName,
      dangerLevel: dangerLevel ?? this.dangerLevel,
      antivenom: antivenom ?? this.antivenom,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      synced: synced ?? this.synced,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'speciesId': speciesId,
      'speciesName': speciesName,
      'scientificName': scientificName,
      'dangerLevel': dangerLevel,
      'antivenom': antivenom,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'synced': synced,
    };
  }

  factory Occurrence.fromMap(Map<String, dynamic> map, [String? docId]) {
    return Occurrence(
      id: docId ?? map['id'] ?? '',
      userId: map['userId'] ?? 'anonymous_user',
      speciesId: map['speciesId'] ?? '',
      speciesName: map['speciesName'] ?? '',
      scientificName: map['scientificName'] ?? '',
      dangerLevel: map['dangerLevel'] ?? '',
      antivenom: map['antivenom'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      synced: map['synced'] ?? false,
    );
  }

  String get locationText => latitude == null || longitude == null
      ? 'Localização indisponível'
      : 'GPS: ${latitude!.toStringAsFixed(5)}, ${longitude!.toStringAsFixed(5)}';

  String generateEmergencyShareText() => [
    'Alerta ToxID • identificação visual preliminar',
    '$speciesName ($scientificName)', locationText,
    if (latitude != null && longitude != null)
      'https://maps.google.com/?q=$latitude,$longitude',
  ].join('\n');
}
