import 'package:flutter/material.dart';
import '../models/species.dart';
import '../services/species_image_cache.dart';
import 'dart:typed_data';

class SpeciesPhoto extends StatelessWidget {
  const SpeciesPhoto({super.key, required this.species});
  final Species species;

  static const photos = {
    'Lachesis muta': 'esp-003',
    'Micrurus corallinus': 'esp-004',
    'Tityus serrulatus': 'esp-005',
    'Tityus stigmurus': 'esp-006',
    'Phoneutria nigriventer': 'esp-007',
    'Lonomia obliqua': 'esp-009',
    'Apis mellifera scutellata': 'esp-010',
    'Rhinella marina': 'esp-011',
    'Crotalus durissus': 'esp-001',
    'Bothrops jararacussu': 'esp-002',
    'Latrodectus curacaviensis': 'esp-008',
    'Phyllobates terribilis': 'esp-012',
  };
  static const groups = {
    'reptiles': 'Reptiles',
    'répteis': 'Reptiles',
    'repteis': 'Reptiles',
    'arácnidos': 'Arácnidos',
    'aracnídeos': 'Arácnidos',
    'aracnideos': 'Arácnidos',
    'anfibios': 'Anfibios',
    'anfíbios': 'Anfibios',
    'insectos': 'Insectos',
    'insetos': 'Insectos',
  };
  static String normalize(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  @override
  Widget build(BuildContext context) {
    final url = species.imageUrl.trim();
    if (url.startsWith('https://')) {
      return FutureBuilder<Uint8List>(
        future: SpeciesImageCache.load(url),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!,
                fit: BoxFit.cover,
                semanticLabel: species.commonName,
                errorBuilder: (_, __, ___) => _fallback());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return _fallback();
        },
      );
    }
    if (url.startsWith('assets/visual/')) {
      return Image.asset(url,
          fit: BoxFit.cover,
          semanticLabel: species.commonName,
          errorBuilder: (_, __, ___) => _fallback());
    }
    return _fallback();
  }

  Widget _fallback() {
    final name = normalize(species.scientificName);
    for (final entry in photos.entries) {
      if (normalize(entry.key) == name) {
        return Image.asset('assets/visual/${entry.value}.webp',
            fit: BoxFit.cover,
            semanticLabel: species.commonName,
            errorBuilder: (_, __, ___) => _illustration());
      }
    }
    return _illustration();
  }

  Widget _illustration() {
    final group = groups[normalize(species.category)];
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      if (group != null)
        Flexible(
            child: Image.asset('assets/visual/$group.webp',
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported_outlined))),
      const Text('Ilustração do grupo', style: TextStyle(fontSize: 12)),
    ]);
  }
}
