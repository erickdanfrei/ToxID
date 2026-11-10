import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import 'admin_panel_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});
  @override
  State<AdminLoginScreen> createState() => _LoginState();
}

class _LoginState extends State<AdminLoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  String message = '';
  Future<void> login(bool google) async {
    final auth = context.read<AuthService>();
    final ok = google ? await auth.signInWithGoogle()
        : await auth.signInWithEmail(email.text, password.text);
    if (!mounted) return;
    if (ok && auth.isAdmin) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminPanelScreen()));
    } else {
      setState(() => message = ok ? 'Conta conectada para sincronizar seu histórico.' :
          'Não foi possível entrar. Confira a conexão e os dados da conta.');
    }
  }
  @override
  void dispose() { email.dispose(); password.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    return Scaffold(appBar: AppBar(title: const Text('Conta ToxID')),
      body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24),
        child: Column(children: [
          Image.asset('assets/visual/logo.webp', height: 82),
          if (auth.isAuthenticated) ...[
            Text(auth.currentUser!.email),
            if (auth.isAdmin) FilledButton(onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AdminPanelScreen())), child: const Text('Painel administrativo')),
            TextButton(onPressed: auth.signOut, child: const Text('Sair')),
          ] else ...[
            TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'E-mail')),
            TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Senha')),
            FilledButton(onPressed: auth.isLoading ? null : () => login(false), child: const Text('Entrar')),
            OutlinedButton(onPressed: auth.isLoading ? null : () => login(true), child: const Text('Entrar com Google')),
          ],
          Text(message),
        ]))));
  }
}
