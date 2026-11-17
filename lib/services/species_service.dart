import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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

  SpeciesService({FirebaseFirestore? firestore}) : _firestore = firestore {
    _loadInitialData();
  }

  List<Species> get speciesList => List.unmodifiable(_speciesList);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _loadInitialData() async {
    _isLoading = _speciesList.isEmpty;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('toxid_species_snapshot_v1');
      if (saved != null) {
        final rows = jsonDecode(saved) as List<dynamic>;
        _speciesList = rows.map((row) {
          final map = Map<String, dynamic>.from(row as Map);
          return Species.fromMap(map, map['id'] as String);
        }).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Catálogo local indisponível: $e');
    }
    try {
      if (_firestore != null) {
        final snapshot = await _firestore!
            .collection('especies')
            .get(const GetOptions(source: Source.serverAndCache));

        if (snapshot.docs.isNotEmpty) {
          _speciesList = snapshot.docs.map((doc) {
            return Species.fromMap(doc.data(), doc.id);
          }).toList();
          await _saveSnapshot();
        } else {
          // Se o banco estiver vazio pela primeira vez, popula com os dados de semente
          _speciesList = List.from(SeedData.initialSpecies);
          _seedFirestore();
        }
      }
    } catch (e) {
      debugPrint('Aviso: Carregando espécies do cache/seed offline: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveSnapshot() async {
    final prefs = await SharedPreferences.getInstance();
    final rows = _speciesList.map((s) => {...s.toMap(), 'id': s.id}).toList();
    if (!await prefs.setString('toxid_species_snapshot_v1', jsonEncode(rows))) {
      throw StateError('Não foi possível salvar o catálogo neste aparelho.');
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
    return searchSpecies(_speciesList,
        query: query,
        category: category,
        dangerLevel: dangerLevel,
        colors: colors);
  }

  // ==========================================
  // OPERAÇÕES DE CRUD (PERFIL ADMINISTRATIVO)
  // ==========================================

  /// [C] - Criar Nova Espécie
  Future<bool> createSpecies(Species species) async {
    _errorMessage = null;
    try {
      if (_firestore == null)
        throw StateError('Firebase indisponível. Cadastro não enviado.');
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
      await _saveSnapshot();
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
    _errorMessage = null;
    try {
      if (_firestore == null)
        throw StateError('Firebase indisponível. Cadastro não enviado.');
      if (_firestore != null) {
        await _firestore!
            .collection('especies')
            .doc(updated.id)
            .update(updated.toMap());
      }

      final index = _speciesList.indexWhere((s) => s.id == updated.id);
      if (index != -1) {
        _speciesList[index] = updated;
        await _saveSnapshot();
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
    _errorMessage = null;
    try {
      if (_firestore == null)
        throw StateError('Firebase indisponível. Cadastro não enviado.');
      if (_firestore != null) {
        await _firestore!.collection('especies').doc(id).delete();
      }

      _speciesList.removeWhere((s) => s.id == id);
      await _saveSnapshot();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao excluir espécie: $e';
      notifyListeners();
      return false;
    }
  }
}
