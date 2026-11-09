import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/species_service.dart';
import 'services/hospital_service.dart';
import 'services/history_service.dart';
import 'screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseAuth? firebaseAuth;
  FirebaseFirestore? firestore;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseAuth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;

    // Habilita persistência offline nativa no Firestore
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  } catch (e) {
    debugPrint(
      'Aviso: Inicialização do Firebase falhou ou está operando em Modo Offline puro: $e',
    );
    // Permite que o app execute perfeitamente mesmo sem conexão ou chaves ativas do Firebase
  }

  runApp(
    ToxIDApp(
      firebaseAuth: firebaseAuth,
      firestore: firestore,
    ),
  );
}

class ToxIDApp extends StatelessWidget {
  final FirebaseAuth? firebaseAuth;
  final FirebaseFirestore? firestore;

  const ToxIDApp({
    super.key,
    this.firebaseAuth,
    this.firestore,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(firebaseAuth: firebaseAuth),
        ),
        ChangeNotifierProvider<SpeciesService>(
          create: (_) => SpeciesService(firestore: firestore),
        ),
        ChangeNotifierProvider<HospitalService>(
          create: (_) => HospitalService(firestore: firestore),
        ),
        ChangeNotifierProvider<HistoryService>(
          create: (_) => HistoryService(firestore: firestore, auth: firebaseAuth),
        ),
      ],
      child: MaterialApp(
        title: 'ToxID - Animais Peçonhentos',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
