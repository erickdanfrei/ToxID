import 'package:flutter_test/flutter_test.dart';
import 'package:toxid/services/hospital_route_service.dart';
import 'package:toxid/services/nearby_hospital_service.dart';

void main() {
  test('GeoJSON usa longitude primeiro; rota preserva distância e tempo', () {
    final route = HospitalRoute.parse({
      'code': 'Ok',
      'routes': [
        {
          'distance': 1200,
          'duration': 180,
          'geometry': {
            'coordinates': [
              [-37.0, -10.9],
              [-37.01, -10.91],
            ],
          },
        },
      ],
    });
    expect(route.points.first.latitude, -10.9);
    expect(route.points.first.longitude, -37.0);
    expect(route.meters, 1200);
    expect(route.seconds, 180);
  });
  test('Sem rota não desenha linha reta como se fosse via', () {
    expect(
      () => HospitalRoute.parse({'code': 'NoRoute', 'routes': []}),
      throwsStateError,
    );
    expect(
      () => HospitalRoute.parse({
        'code': 'Ok',
        'routes': [
          {
            'distance': 1,
            'duration': 2,
            'geometry': {
              'coordinates': [
                [0, 95],
                [0, 0],
              ],
            },
          },
        ],
      }),
      throwsStateError,
    );
  });
  test('Hospital no mapa não recebe estoque de soro presumido', () {
    final hospitals = NearbyHospitalService.parseElements([
      {
        'type': 'node',
        'id': 1,
        'lat': -10.9,
        'lon': -37.0,
        'tags': {'amenity': 'hospital', 'name': 'Hospital'},
      },
      {
        'type': 'way',
        'id': 2,
        'center': {'lat': -10.91, 'lon': -37.01},
        'tags': {'healthcare': 'hospital'},
      },
      {
        'type': 'node',
        'id': 3,
        'lat': 999,
        'lon': 0,
        'tags': {'amenity': 'hospital'},
      },
    ]);
    expect(hospitals.length, 2);
    expect(hospitals.every((h) => h.availableSerums.isEmpty), isTrue);
  });
}
