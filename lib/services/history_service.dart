import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/occurrence.dart';

class HistoryService extends ChangeNotifier {
  HistoryService({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _db = firestore, _auth = auth {
    _ready = _load();
    _subscription = auth?.authStateChanges().listen((_) {
      notifyListeners();
      unawaited(syncWithFirebase());
    });
    _retry = Timer.periodic(const Duration(seconds: 30), (_) => syncWithFirebase());
  }
  final FirebaseFirestore? _db;
  final FirebaseAuth? _auth;
  final _records = <String, Occurrence>{};
  late Future<void> _ready;
  late Timer _retry;
  StreamSubscription<User?>? _subscription;
  bool isSyncing = false;
  String get _owner => _auth?.currentUser?.uid ?? 'anonymous_user';

  List<Occurrence> get occurrences => _records.values.where((o) => o.userId == _owner)
      .toList()..sort((a,b) => b.timestamp.compareTo(a.timestamp));

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in prefs.getKeys().where((k) => k.startsWith('toxid:'))) {
      final value = prefs.getString(key);
      if (value != null) {
        final entry = Occurrence.fromMap(jsonDecode(value) as Map<String,dynamic>);
        _records[key] = entry;
      }
    }
    notifyListeners();
  }

  Future<void> _persist(Occurrence entry) async {
    final key = 'toxid:${entry.userId}:${entry.id}';
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setString(key, jsonEncode(entry.toMap()))) {
      throw StateError('Falha ao salvar no dispositivo.');
    }
    _records[key] = entry;
    notifyListeners();
  }

  Future<void> addOccurrence(Occurrence entry) async {
    final owner = _owner;
    await _ready;
    await _persist(entry.copyWith(userId: owner));
    unawaited(syncWithFirebase());
  }

  Future<void> syncWithFirebase() async {
    await _ready;
    final user = _auth?.currentUser;
    if (user == null || _db == null || isSyncing || !occurrences.any((e) => !e.synced)) return;
    isSyncing = true;
    notifyListeners();
    try {
      final collection = _db!.collection('usuarios').doc(user.uid).collection('historico');
      for (final entry in occurrences.where((o) => !o.synced)) {
        if (_owner != user.uid) break;
        await collection.doc(entry.id).set(entry.toMap());
        await _persist(entry.copyWith(synced: true));
      }
    } on FirebaseException catch (e) {
      debugPrint('Sincronização pendente: ${e.code}');
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }
  @override
  void dispose() { _subscription?.cancel(); _retry.cancel(); super.dispose(); }
}
