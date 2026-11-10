import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import 'triage_feature_screen.dart';

/// Passo 1 do Modo Emergência: Triagem Visual Inicial
/// "¿Cómo era el animal?" (Répteis, Aracnídeos, Anfíbios, Insetos)
/// Atende a: RF02, RNF01.
class TriageCategoryScreen extends StatelessWidget {
  const TriageCategoryScreen({super.key});

  Future<void> _callEmergency() async {
    final uri = Uri.parse('tel:192');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passo 1 de 2: Triagem'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '¿Como era o animal?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Selecione a categoria visual que mais se parece com o animal do acidente:',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Grid com as 4 categorias visuais
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.95,
                      children: [
                        _buildCategoryCard(
                          context: context,
                          title: 'Répteis',
                          subtitle: 'Serpentes / Cobras',
                          icon: Icons.gesture,
                          categoryKey: 'Reptiles',
                          accentColor: AppTheme.emergencyRed,
                        ),
                        _buildCategoryCard(
                          context: context,
                          title: 'Aracnídeos',
                          subtitle: 'Aranhas e Escorpiões',
                          icon: Icons.pest_control,
                          categoryKey: 'Arácnidos',
                          accentColor: AppTheme.warningOrange,
                        ),
                        _buildCategoryCard(
                          context: context,
                          title: 'Anfíbios',
                          subtitle: 'Sapos e Rãs',
                          icon: Icons.water_drop,
                          categoryKey: 'Anfibios',
                          accentColor: AppTheme.primaryGreen,
                        ),
                        _buildCategoryCard(
                          context: context,
                          title: 'Insetos',
                          subtitle: 'Lagartas, Abelhas, etc.',
                          icon: Icons.bug_report,
                          categoryKey: 'Insectos',
                          accentColor: AppTheme.cautionYellow,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Botão fixo inferior de emergência
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.darkBackground,
                border: Border(
                  top: BorderSide(color: AppTheme.borderColor),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _callEmergency,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.callGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.phone_in_talk, color: Colors.white),
                  label: const Text(
                    'Ligue Agora (SAMU 192)',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String categoryKey,
    required Color accentColor,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TriageFeatureScreen(category: categoryKey),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.borderColor, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Image.asset('assets/visual/$categoryKey.webp', fit: BoxFit.contain)),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textLight,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
