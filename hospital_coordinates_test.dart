import 'package:flutter_test/flutter_test.dart';
import 'package:toxid/domain/hospital_coordinates.dart';
import 'package:toxid/services/hospital_service.dart';
void main() {
  test('Coordenadas aceitam ponto, vírgula e espaços', () {
    expect(parseHospitalCoordinate(' -10,1234 '), -10.1234);
    expect(parseHospitalCoordinate('-37.1234'), -37.1234);
  });
  test('Entrada inválida não vira coordenada de Goiânia', () {
    for (final s in ['', 'abc', 'NaN', 'Infinity', '-10,1,2']) {
      expect(validateHospitalCoordinate(s, latitude: true), isNotNull);
    }
    expect(validateHospitalCoordinate('91', latitude:true), isNotNull);
    expect(validateHospitalCoordinate('-181', latitude:false), isNotNull);
    expect(validateHospitalCoordinate('-90', latitude:true), isNull);
    expect(validateHospitalCoordinate('180', latitude:false), isNull);
  });
  test('Atualização sem Firebase não alega sucesso nem altera memória', () async {
    final service=HospitalService();
    final hospital=service.hospitals.first;
    expect(await service.updateHospital(hospital.copyWith(latitude:-10.1234)),isFalse);
    expect(service.hospitals.first.latitude,hospital.latitude);
    expect(service.errorMessage,isNotNull);
    service.dispose();
  });
}
