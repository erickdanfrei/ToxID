import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:toxid/services/hospital_service.dart';
import 'package:toxid/screens/hospitals/hospitals_screen.dart';
import 'package:toxid/theme/app_theme.dart';

void main() {
  testWidgets('Mantém título, cartões e SAMU sem pedir GPS ao abrir', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final service = HospitalService();
    await tester.pumpWidget(
      ChangeNotifierProvider<HospitalService>.value(
        value: service,
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: const HospitalsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Hospitais de Referência'), findsOneWidget);
    expect(find.text('Ativar mapa e GPS'), findsOneWidget);
    expect(find.text('Ligue Agora (SAMU 192)'), findsOneWidget);
    expect(find.text('Mapa ilustrativo do protótipo • Goiânia'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    service.dispose();
  });
}
