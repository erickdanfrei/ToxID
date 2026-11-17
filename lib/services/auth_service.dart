import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/app_user.dart';

class AuthService extends ChangeNotifier {
  AuthService({FirebaseAuth? firebaseAuth}) : _auth = firebaseAuth {
    _subscription = _auth?.idTokenChanges().listen(_update);
  }
  final FirebaseAuth? _auth;
  StreamSubscription<User?>? _subscription;
  AppUser? currentUser;
  bool isLoading = false;
  String? lastError;

  String _describeAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'unauthorized-domain':
        return 'Domínio não autorizado pelo Firebase. Adicione toxid.vercel.app em Authentication > Settings > Authorized domains.';
      case 'operation-not-allowed':
        return 'O provedor Google não está habilitado no Firebase Authentication.';
      case 'popup-blocked':
        return 'O navegador bloqueou a janela do Google. Permita pop-ups e tente novamente.';
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return 'O login Google foi cancelado. Tente novamente.';
      case 'network-request-failed':
        return 'Sem internet. O login Google exige conexão; o catálogo local pode ser usado offline.';
      case 'account-exists-with-different-credential':
        return 'Já existe uma conta com este e-mail e outro método de login.';
      default:
        return 'Erro de autenticação Firebase (${e.code}). Verifique o provedor Google e o domínio autorizado.';
    }
  }
  bool get isAdmin => currentUser?.isAdmin == true;
  bool get isAuthenticated => currentUser != null;

  Future<void> _update(User? user) async {
    IdTokenResult? token;
    if (user != null) {
      try {
        token = await user.getIdTokenResult();
      } catch (e) {
        // O usuário pode estar autenticado localmente mesmo sem rede.
        debugPrint('Não foi possível atualizar as permissões agora: $e');
      }
    }
    if (_auth?.currentUser?.uid != user?.uid) return;
    currentUser = user == null ? null : AppUser(uid: user.uid,
      email: user.email ?? '', displayName: user.displayName ?? 'Usuário',
      role: token?.claims?['admin'] == true ? 'admin' : 'user');
    notifyListeners();
  }

  Future<bool> _login(Future<UserCredential> Function(FirebaseAuth) login) async {
    final auth = _auth;
    if (auth == null) {
      lastError = 'Firebase não inicializado. Confira firebase_options.dart.';
      notifyListeners();
      return false;
    }
    if (isLoading) return false;
    isLoading = true;
    lastError = null;
    notifyListeners();
    try {
      final credential = await login(auth);
      await _update(credential.user);
      if (currentUser == null) {
        lastError = 'Login retornou sem um usuário autenticado.';
        return false;
      }
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth: ${e.code}: ${e.message}');
      lastError = _describeAuthError(e);
      return false;
    } catch (e) {
      debugPrint('Falha inesperada ao autenticar: $e');
      lastError = 'Não foi possível entrar ($e).';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithEmail(String email, String password) =>
    _login((auth) => auth.signInWithEmailAndPassword(email: email.trim(), password: password));

  Future<bool> signInWithGoogle() => _login((auth) async {
    if (kIsWeb) return auth.signInWithPopup(GoogleAuthProvider());
    final account = await GoogleSignIn().signIn();
    if (account == null) throw StateError('Login cancelado');
    final tokens = await account.authentication;
    return auth.signInWithCredential(GoogleAuthProvider.credential(
        accessToken: tokens.accessToken, idToken: tokens.idToken));
  });

  Future<void> signOut() async { await _auth?.signOut(); }
  @override
  void dispose() { _subscription?.cancel(); super.dispose(); }
}
