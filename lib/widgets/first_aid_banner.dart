import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Alertas visuais de Primeiros Socorros pós-acidente.
/// Atende estritamente a:
/// - RF08: O sistema deve exibir instruções visuais de primeiros socorros ao finalizar o diagnóstico.
/// - RF09: O sistema deve exibir alertas vermelhos sobre procedimentos contraindicados em acidentes.
class FirstAidBanner extends StatelessWidget {
  final List<String> doList;
  final List<String> dontList;

  const FirstAidBanner({
    super.key,
    required this.doList,
    required this.dontList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Bloco Vermelho - O QUE NÃO FAZER (Contraindicações críticas)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2D1414),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.alertRed.withOpacity(0.6), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.dangerous, color: AppTheme.alertRed, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'O QUE NÃO DEVE FAZER',
                    style: TextStyle(
                      color: AppTheme.alertRed,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...dontList.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('✕ ',
                            style: TextStyle(
                                color: AppTheme.alertRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Bloco Verde - O QUE VOCÊ DEVE FAZER (Orientações imediatas)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF13281A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.6), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.check_circle_outline, color: AppTheme.primaryGreen, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'O QUE VOCÊ DEVE FAZER',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...doList.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('✓ ',
                            style: TextStyle(
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
