import '../models/hospital.dart';

// Identifica códigos informados pelo administrador, não estoque confirmado.
Set<String> serumCodes(String text) => RegExp(
  r'\b(SABR|SABC|SABL|SAB|SAC|SAEL|SAESC|SAE|SAAR|SALON|SALOX)\b',
).allMatches(text.toUpperCase()).map((m) {
  final code = m.group(0)!;
  return code == 'SAEL' ? 'SAE' : code == 'SABR' ? 'SAB' : code;
}).toSet();

List<Hospital> hospitalsWithRegisteredSerum(Iterable<Hospital> hospitals,
    {String? requiredSerum}) {
  final requested = serumCodes(requiredSerum ?? '');
  final hasFilter = requiredSerum != null && requiredSerum.trim().isNotEmpty;
  return hospitals.where((hospital) {
    final available = hospital.availableSerums.expand(serumCodes).toSet();
    if (available.isEmpty) return false;
    if (!hasFilter) return true;
    // Não troca um soro por outro nem ignora um filtro desconhecido.
    return requested.isNotEmpty && requested.any(available.contains);
  }).toList();
}
