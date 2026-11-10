import '../models/species.dart';
import 'species_labels.dart';

List<Species> searchSpecies(Iterable<Species> species, {
  String query = '', String category = 'Todas', String? dangerLevel,
  List<String> colors = const [],
}) {
  final q = searchKey(query);
  final categoryKey = searchKey(categoryLabel(category));
  final dangerKey = searchKey(dangerLabel(dangerLevel ?? ''));
  final selectedColors = colors.map((c) => searchKey(colorLabel(c))).toSet();
  return species.where((sp) {
    if(q.isNotEmpty && !searchKey(sp.commonName).contains(q) &&
        !searchKey(sp.scientificName).contains(q)) return false;
    if(categoryKey.isNotEmpty && categoryKey != 'todas' &&
        searchKey(categoryLabel(sp.category)) != categoryKey) return false;
    if(dangerKey.isNotEmpty && searchKey(dangerLabel(sp.dangerLevel)) != dangerKey) return false;
    final speciesColors = sp.colors.map((c) => searchKey(colorLabel(c))).toSet();
    if(selectedColors.isNotEmpty && !selectedColors.any(speciesColors.contains)) return false;
    return true;
  }).toList();
}
