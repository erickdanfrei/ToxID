import '../models/species.dart';

List<Species> searchSpecies(Iterable<Species> species, {
  String query = '', String category = 'Todas', String? dangerLevel,
  List<String> colors = const [],
}) {
    return species.where((sp) {
      // Filtro de texto (busca no nome popular e científico)
      if (query.isNotEmpty) {
        final q = query.toLowerCase();
        final matchPopular = sp.commonName.toLowerCase().contains(q);
        final matchScientific = sp.scientificName.toLowerCase().contains(q);
        if (!matchPopular && !matchScientific) return false;
      }

      // Filtro de categoria
      if (category != 'Todas' && category.isNotEmpty) {
        if (!sp.category.toLowerCase().contains(category.toLowerCase())) {
          return false;
        }
      }

      // Filtro de periculosidade
      if (dangerLevel != null && dangerLevel.isNotEmpty) {
        if (sp.dangerLevel.toLowerCase() != dangerLevel.toLowerCase()) {
          return false;
        }
      }

      // Filtro de cores (se selecionou alguma cor, a espécie deve possuir ao menos uma)
      if (colors.isNotEmpty) {
        final hasColorMatch = colors.any((selectedColor) => sp.colors.any(
            (c) => c.toLowerCase().contains(selectedColor.toLowerCase())));
        if (!hasColorMatch) return false;
      }

      return true;
    }).toList();
}
