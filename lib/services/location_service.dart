import 'package:geolocator/geolocator.dart';

/// Obtém uma posição pontual. A ocorrência salva coordenadas somente quando disponíveis.
class LocationService {
  // Coordenada padrão de referência caso o GPS esteja desativado ou negado
  // (Ponto central: Goiânia/GO - referência do protótipo)
  static const double defaultLat = -16.6869;
  static const double defaultLng = -49.2648;

  Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 15),
      );
    } catch (e) {
      // Falha graciosa sem interromper o fluxo de emergência
      return null;
    }
  }
}
