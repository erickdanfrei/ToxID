import '../domain/species_search.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/species.dart';
import 'seed_data.dart';

/// Serviço de Gerenciamento das Espécies de Animais Peçonhentos.
/// Implementa persistência no Cloud Firestore com cache e fallback offline garantido.
///
/// Regras de Negócio:
/// - Usuário comum: Apenas Leitura (R - Read).
/// - Administrador autenticado: CRUD completo (Create, Read, Update, Delete).
class SpeciesService extends ChangeNotifier {
  final FirebaseFirestore? _firestore;
  List<Species> _speciesList = List.from(SeedData.initialSpecies);
  bool _isLoading = false;
  String? _errorMessage;

  SpeciesService({FirebaseFirestore? firestore})
      : _firestore = firestore {
    _loadInitialData();
  }

  List<Species> get speciesList => List.unmodifiable(_speciesList);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _loadInitialData() async {
    _isLoading = _speciesList.isEmpty;
    notifyListeners();

    try {
      if (_firestore != null) {
        final snapshot = await _firestore!
            .collection('especies')
            .get(const GetOptions(source: Source.serverAndCache));

        if (snapshot.docs.isNotEmpty) {
          _speciesList = snapshot.docs.map((doc) {
            return Species.fromMap(doc.data(), doc.id);
          }).toList();
        } else {
          // Se o banco estiver vazio pela primeira vez, popula com os dados de semente
          _speciesList = List.from(SeedData.initialSpecies);
          _seedFirestore();
        }
      } else {
        _speciesList = List.from(SeedData.initialSpecies);
      }
    } catch (e) {
      debugPrint('Aviso: Carregando espécies do cache/seed offline: $e');
      _speciesList = List.from(SeedData.initialSpecies);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _seedFirestore() async {
    if (_firestore == null) return;
    try {
      final batch = _firestore!.batch();
      for (final sp in SeedData.initialSpecies) {
        final docRef = _firestore!.collection('especies').doc(sp.id);
        batch.set(docRef, sp.toMap());
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Falha ao popular semente no Firestore: $e');
    }
  }

  /// Busca espécie pelo identificador
  Species? getById(String id) {
    try {
      return _speciesList.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Filtro dinâmico por texto de busca, categoria, periculosidade e cores
  List<Species> filterSpecies({
    String query = '',
    String category = 'Todas',
    String? dangerLevel,
    List<String> colors = const [],
  }) {
    return searchSpecies(_speciesList, query: query, category: category,
        dangerLevel: dangerLevel, colors: colors);
  }

  // ==========================================
  // OPERAÇÕES DE CRUD (PERFIL ADMINISTRATIVO)
  // ==========================================

  /// [C] - Criar Nova Espécie
  Future<bool> createSpecies(Species species) async {
    try {
      String newId = species.id.isNotEmpty
          ? species.id
          : 'esp-${DateTime.now().millisecondsSinceEpoch}';
      final newSpecies = species.copyWith(id: newId);

      if (_firestore != null) {
        await _firestore!
            .collection('especies')
            .doc(newId)
            .set(newSpecies.toMap());
      }

      _speciesList.insert(0, newSpecies);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao salvar espécie: $e';
      notifyListeners();
      return false;
    }
  }

  /// [U] - Atualizar Espécie Existente
  Future<bool> updateSpecies(Species updated) async {
    try {
      if (_firestore != null) {
        await _firestore!
            .collection('especies')
            .doc(updated.id)
            .update(updated.toMap());
      }

      final index = _speciesList.indexWhere((s) => s.id == updated.id);
      if (index != -1) {
        _speciesList[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao atualizar espécie: $e';
      notifyListeners();
      return false;
    }
  }

  /// [D] - Excluir Espécie
  Future<bool> deleteSpecies(String id) async {
    try {
      if (_firestore != null) {
        await _firestore!.collection('especies').doc(id).delete();
      }

      _speciesList.removeWhere((s) => s.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao excluir espécie: $e';
      notifyListeners();
      return false;
    }
  }
}
