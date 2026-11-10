import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import 'admin/admin_login_screen.dart';
import 'history/history_screen.dart';
import 'triage/triage_category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onNavigateToTab});
  final ValueChanged<int> onNavigateToTab;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(actions: [
      IconButton(tooltip: 'Histórico', icon: const Icon(Icons.history),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()))),
      IconButton(tooltip: 'Conta', icon: const Icon(Icons.person_outline),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminLoginScreen()))),
    ]),
    body: Center(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 32),
      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Image.asset('assets/visual/logo.webp', height: 82),
          const SizedBox(height: 12),
          const Text('Seu guia em uma emergência. Procure atendimento médico.',
            textAlign: TextAlign.center, style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          FilledButton(style: FilledButton.styleFrom(backgroundColor: AppTheme.emergencyRed,
            foregroundColor: Colors.white, minimumSize: const Size(0, 124),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TriageCategoryScreen())),
            child: const Column(children: [Icon(Icons.warning_amber, size: 36), SizedBox(height: 8),
              Text('Não sei o que me picou', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))])),
          const SizedBox(height: 24),
          FilledButton.icon(style: FilledButton.styleFrom(minimumSize: const Size(0, 68),
            backgroundColor: AppTheme.callGreen, foregroundColor: Colors.white),
            onPressed: () async {
              if (!await launchUrl(Uri.parse('tel:192')) && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Discador indisponível. SAMU: 192.')));
              }
            }, icon: const Icon(Icons.phone_in_talk), label: const Text('Ligar agora • 192')),
        ])))));
}
