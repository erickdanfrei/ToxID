import 'package:flutter_test/flutter_test.dart';
import 'package:toxid/models/hospital.dart';
import 'package:toxid/domain/hospital_serum_filter.dart';
Hospital unit(String id,List<String> serums) => Hospital(id:id,name:id,state:'SE',city:'Aracaju',address:'',phone:'',latitude:-10.9,longitude:-37,availableSerums:serums);
void main() {
  final hospitals=[unit('geral',[]),unit('vazio',[' ']),unit('referencia',['SAB','SAEsc']),unit('elapidico',['SAEl'])];
  test('Exclui hospitais sem soro informado', () {
    expect(hospitalsWithRegisteredSerum(hospitals).map((h)=>h.id),['referencia','elapidico']);
  });
  test('SAE não confunde com SAEsc; filtro funciona sem GPS', () {
    expect(hospitalsWithRegisteredSerum(hospitals,requiredSerum:'SAE - Soro Antielapídico').map((h)=>h.id),['elapidico']);
    expect(hospitalsWithRegisteredSerum(hospitals,requiredSerum:'SAEsc').map((h)=>h.id),['referencia']);
  });
  test('Filtro sem correspondência não mostra hospitais gerais', () {
    expect(hospitalsWithRegisteredSerum(hospitals,requiredSerum:'SALon'),isEmpty);
    expect(hospitalsWithRegisteredSerum(hospitals,requiredSerum:'Suporte clínico'),isEmpty);
    expect(hospitalsWithRegisteredSerum([unit('outro',['Não informado'])]),isEmpty);
  });
}
