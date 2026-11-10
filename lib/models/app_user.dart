/// Modelo do Usuário do Sistema
/// Diferencia usuários comuns (modo consulta/emergência) do perfil administrativo.
class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String role; // 'admin' ou 'user'

  const AppUser({
    required this.uid,
    required this.email,
    this.displayName = '',
    this.role = 'user',
  });

  bool get isAdmin => role == 'admin';

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map, [String? docId]) {
    return AppUser(
      uid: docId ?? map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      role: map['role'] ?? 'user',
    );
  }
}
