/// Coordenadas decimais; não presume localização para entradas inválidas.
double? parseHospitalCoordinate(String? value) {
  final parsed = double.tryParse((value ?? '').trim().replaceAll(',', '.'));
  return parsed != null && parsed.isFinite ? parsed : null;
}
String? validateHospitalCoordinate(String? value, {required bool latitude}) {
  final parsed = parseHospitalCoordinate(value);
  if (parsed == null) return 'Informe um número válido';
  final limit = latitude ? 90 : 180;
  if (parsed.abs() > limit) return 'Use valores entre -$limit e $limit';
  return null;
}
