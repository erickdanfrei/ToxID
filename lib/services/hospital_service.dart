import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import '../models/hospital.dart';
import 'seed_data.dart';
import 'location_service.dart';

/// Serviço de Gestão e Localização de Hospitais de Referência Antiveneno.
/// Implementa ordenação por proximidade geográfica e persistência no Cloud Firestore.
///
/// Atende aos requisitos RF05 e RNF06.
class HospitalService extends ChangeNotifier {
  final FirebaseFirestore? _firestore;
  List<Hospital> _hospitals = List.from(SeedData.initialHospitals);
  bool _isLoading = false;
  String? _errorMessage;

  HospitalService({FirebaseFirestore? firestore})
      : _firestore = firestore {
    _loadInitialData();
  }

  List<Hospital> get hospitals => List.unmodifiable(_hospitals);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _loadInitialData() async {
    _isLoading = _hospitals.isEmpty;
    notifyListeners();

    try {
      if (_firestore != null) {
        final snapshot = await _firestore!
            .collection('hospitais')
            .get(const GetOptions(source: Source.serverAndCache));

        if (snapshot.docs.isNotEmpty) {
          _hospitals = snapshot.docs.map((doc) {
            return Hospital.fromMap(doc.data(), doc.id);
          }).toList();
        } else {
          _hospitals = List.from(SeedData.initialHospitals);
          _seedFirestore();
        }
      } else {
        _hospitals = List.from(SeedData.initialHospitals);
      }
    } catch (e) {
      debugPrint('Aviso: Carregando hospitais do seed offline: $e');
      _hospitals = List.from(SeedData.initialHospitals);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _seedFirestore() async {
    if (_firestore == null) return;
    try {
      final batch = _firestore!.batch();
      for (final h in SeedData.initialHospitals) {
        final docRef = _firestore!.collection('hospitais').doc(h.id);
        batch.set(docRef, h.toMap());
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Falha ao popular semente de hospitais no Firestore: $e');
    }
  }

  /// Retorna a lista de hospitais ordenada pela menor distância do usuário
  List<Hospital> getNearbyHospitals({
    double userLat = LocationService.defaultLat,
    double userLng = LocationService.defaultLng,
    String? requiredSerum,
  }) {
    List<Hospital> filtered = List.from(_hospitals);

    if (requiredSerum != null && requiredSerum.isNotEmpty) {
      filtered = filtered.where((h) {
        return h.availableSerums.any((s) =>
            requiredSerum.toLowerCase().contains(s.toLowerCase()) ||
            s.toLowerCase().contains(requiredSerum.toLowerCase()));
      }).toList();
    }

    filtered.sort((a, b) {
      final distA = a.distanceFrom(userLat, userLng);
      final distB = b.distanceFrom(userLat, userLng);
      return distA.compareTo(distB);
    });

    return filtered;
  }

  // ==========================================
  // OPERAÇÕES DE CRUD (PERFIL ADMINISTRATIVO)
  // ==========================================

  /// [C] - Adicionar Novo Hospital
  Future<bool> createHospital(Hospital hospital) async {
    _errorMessage = null;
    try {
      if (_firestore == null) throw StateError('Firebase não inicializado. Alteração não salva.');
      String newId = hospital.id.isNotEmpty
          ? hospital.id
          : 'hosp-${DateTime.now().millisecondsSinceEpoch}';
      final newHospital = hospital.copyWith(id: newId);

      if (_firestore != null) {
        await _firestore!
            .collection('hospitais')
            .doc(newId)
            .set(newHospital.toMap());
      }

      _hospitals.insert(0, newHospital);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao cadastrar hospital: $e';
      notifyListeners();
      return false;
    }
  }

  /// [U] - Atualizar Dados do Hospital
  Future<bool> updateHospital(Hospital updated) async {
    _errorMessage = null;
    try {
      if (_firestore == null) throw StateError('Firebase não inicializado. Alteração não salva.');
      if (_firestore != null) {
        await _firestore!
            .collection('hospitais')
            .doc(updated.id)
            .set(updated.toMap(), SetOptions(merge: true));
      }

      final index = _hospitals.indexWhere((h) => h.id == updated.id);
      if (index != -1) {
        _hospitals[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e is FirebaseException && e.code == 'permission-denied'
          ? 'Sem permissão para salvar. Entre com uma conta administradora e confira as regras do Firestore.'
          : 'Não foi possível salvar o hospital. Confira a conexão. Detalhe: $e';
      notifyListeners();
      return false;
    }
  }

  /// [D] - Remover Hospital
  Future<bool> deleteHospital(String id) async {
    _errorMessage = null;
    try {
      if (_firestore == null) throw StateError('Firebase não inicializado. Alteração não salva.');
      if (_firestore != null) {
        await _firestore!.collection('hospitais').doc(id).delete();
      }

      _hospitals.removeWhere((h) => h.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao excluir hospital: $e';
      notifyListeners();
      return false;
    }
  }
}
