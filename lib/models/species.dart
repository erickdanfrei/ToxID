/// Modelo de domínio que representa uma Espécie de animal peçonhento.
/// Mapeado diretamente para a coleção 'especies' no Cloud Firestore.
class Species {
  final String id;
  final String commonName;
  final String scientificName;
  final String category; // Reptiles, Arácnidos, Anfibios, Insectos
  final String dangerLevel; // Muy Peligrosa, Peligrosa, Bajo Peligro, No Peligrosa
  final String antivenom;
  final List<String> colors;
  final List<String> characteristics;
  final String description;
  final String distribution;
  final String imageUrl;
  final List<String> firstAidDo;
  final List<String> firstAidDont;

  const Species({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.category,
    required this.dangerLevel,
    required this.antivenom,
    this.colors = const [],
    this.characteristics = const [],
    this.description = '',
    this.distribution = '',
    this.imageUrl = '',
    this.firstAidDo = const [],
    this.firstAidDont = const [],
  });

  bool get isVeryDangerous =>
      dangerLevel.toLowerCase().contains('muy') ||
      dangerLevel.toLowerCase().contains('alta');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'commonName': commonName,
      'scientificName': scientificName,
      'category': category,
      'dangerLevel': dangerLevel,
      'antivenom': antivenom,
      'colors': colors,
      'characteristics': characteristics,
      'description': description,
      'distribution': distribution,
      'imageUrl': imageUrl,
      'firstAidDo': firstAidDo,
      'firstAidDont': firstAidDont,
    };
  }

  factory Species.fromMap(Map<String, dynamic> map, [String? docId]) {
    return Species(
      id: docId ?? map['id'] ?? '',
      commonName: map['commonName'] ?? '',
      scientificName: map['scientificName'] ?? '',
      category: map['category'] ?? 'Outros',
      dangerLevel: map['dangerLevel'] ?? 'Peligrosa',
      antivenom: map['antivenom'] ?? 'Suporte Médico Imediato',
      colors: List<String>.from(map['colors'] ?? []),
      characteristics: List<String>.from(map['characteristics'] ?? []),
      description: map['description'] ?? '',
      distribution: map['distribution'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      firstAidDo: List<String>.from(map['firstAidDo'] ?? []),
      firstAidDont: List<String>.from(map['firstAidDont'] ?? []),
    );
  }

  Species copyWith({
    String? id,
    String? commonName,
    String? scientificName,
    String? category,
    String? dangerLevel,
    String? antivenom,
    List<String>? colors,
    List<String>? characteristics,
    String? description,
    String? distribution,
    String? imageUrl,
    List<String>? firstAidDo,
    List<String>? firstAidDont,
  }) {
    return Species(
      id: id ?? this.id,
      commonName: commonName ?? this.commonName,
      scientificName: scientificName ?? this.scientificName,
      category: category ?? this.category,
      dangerLevel: dangerLevel ?? this.dangerLevel,
      antivenom: antivenom ?? this.antivenom,
      colors: colors ?? this.colors,
      characteristics: characteristics ?? this.characteristics,
      description: description ?? this.description,
      distribution: distribution ?? this.distribution,
      imageUrl: imageUrl ?? this.imageUrl,
      firstAidDo: firstAidDo ?? this.firstAidDo,
      firstAidDont: firstAidDont ?? this.firstAidDont,
    );
  }
}
