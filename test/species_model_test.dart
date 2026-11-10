import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toxid/models/occurrence.dart';
import 'package:toxid/services/history_service.dart';
import 'package:toxid/services/seed_data.dart';
import 'package:toxid/services/species_service.dart';import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toxid/models/occurrence.dart';
import 'package:toxid/services/history_service.dart';
import 'package:toxid/services/seed_data.dart';
import 'package:toxid/services/species_service.dart';
import 'package:toxid/services/auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final unknownLocation = Occurrence(id: 'abc', speciesId: 's', speciesName: 'Animal',
    scientificName: '', dangerLevel: '', antivenom: '', timestamp: DateTime(2026),
    latitude: null, longitude: null);
  test('GPS negado permanece ausente no armazenamento e no alerta', () {
    final roundTrip = Occurrence.fromMap(unknownLocation.toMap());
    expect(roundTrip.latitude, isNull);
    expect(roundTrip.generateEmergencyShareText(), isNot(contains('maps.google')));
  });
  test('Alerta com GPS inclui as duas coordenadas', () {
    expect(unknownLocation.copyWith(latitude: -10, longitude: -37)
        .generateEmergencyShareText(), contains('q=-10.0,-37.0'));
  });
  test('Filtro de risco não mistura níveis com texto parecido', () {
    final service = SpeciesService();
    final level = SeedData.initialSpecies.firstWhere((s) => s.dangerLevel == 'Perigosa').dangerLevel;
    final filtered = service.filterSpecies(dangerLevel: level);
    expect(filtered, isNotEmpty);
    expect(filtered.every((s) => s.dangerLevel == level), isTrue);
  });
  test('Falha de autenticação não concede acesso administrativo', () async {
    final auth = AuthService();
    expect(await auth.signInWithEmail('admin@toxid.org', 'admin123'), isFalse);
    expect(await auth.signInWithGoogle(), isFalse);
    expect(auth.isAdmin, isFalse);
  });
  test('Histórico sobrevive à recriação do serviço sem Firebase', () async {
    SharedPreferences.setMockInitialValues({});
    final first = HistoryService();
    await first.addOccurrence(unknownLocation);
    first.dispose();
    final restored = HistoryService();
    await restored.syncWithFirebase();
    expect(restored.occurrences.single.id, unknownLocation.id);
    expect(restored.occurrences.single.synced, isFalse);
    restored.dispose();
  });
}

import 'package:toxid/services/auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final unknownLocation = Occurrence(id: 'abc', speciesId: 's', speciesName: 'Animal',
    scientificName: '', dangerLevel: '', antivenom: '', timestamp: DateTime(2026),
    latitude: null, longitude: null);
  test('GPS negado permanece ausente no armazenamento e no alerta', () {
    final roundTrip = Occurrence.fromMap(unknownLocation.toMap());
    expect(roundTrip.latitude, isNull);
    expect(roundTrip.generateEmergencyShareText(), isNot(contains('maps.google')));
  });
  test('Alerta com GPS inclui as duas coordenadas', () {
    expect(unknownLocation.copyWith(latitude: -10, longitude: -37)
        .generateEmergencyShareText(), contains('q=-10.0,-37.0'));
  });
  test('Filtro de risco não mistura níveis com texto parecido', () {
    final service = SpeciesService();
    final level = SeedData.initialSpecies.firstWhere((s) => s.dangerLevel == 'Peligrosa').dangerLevel;
    final filtered = service.filterSpecies(dangerLevel: level);
    expect(filtered, isNotEmpty);
    expect(filtered.every((s) => s.dangerLevel == level), isTrue);
  });
  test('Falha de autenticação não concede acesso administrativo', () async {
    final auth = AuthService();
    expect(await auth.signInWithEmail('admin@toxid.org', 'admin123'), isFalse);
    expect(await auth.signInWithGoogle(), isFalse);
    expect(auth.isAdmin, isFalse);
  });
  test('Histórico sobrevive à recriação do serviço sem Firebase', () async {
    SharedPreferences.setMockInitialValues({});
    final first = HistoryService();
    await first.addOccurrence(unknownLocation);
    first.dispose();
    final restored = HistoryService();
    await restored.syncWithFirebase();
    expect(restored.occurrences.single.id, unknownLocation.id);
    expect(restored.occurrences.single.synced, isFalse);
    restored.dispose();
  });
}
