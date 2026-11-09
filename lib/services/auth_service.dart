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
  bool get isAdmin => currentUser?.isAdmin == true;
  bool get isAuthenticated => currentUser != null;

  Future<void> _update(User? user) async {
    final token = await user?.getIdTokenResult();
    if (_auth?.currentUser?.uid != user?.uid) return;
    currentUser = user == null ? null : AppUser(uid: user.uid,
      email: user.email ?? '', displayName: user.displayName ?? 'Usuário',
      role: token?.claims?['admin'] == true ? 'admin' : 'user');
    notifyListeners();
  }

  Future<bool> _login(Future<UserCredential> Function(FirebaseAuth) login) async {
    final auth = _auth;
    if (auth == null || isLoading) return false;
    isLoading = true;
    notifyListeners();
    try {
      final credential = await login(auth);
      await _update(credential.user);
      return currentUser != null;
    } catch (_) {
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
