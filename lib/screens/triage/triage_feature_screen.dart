import '../../domain/species_labels.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import 'triage_result_screen.dart';

/// Passo 2 do Modo Emergência: Pergunta Visual de Detalhe
/// "¿Qué característica recuerdas mejor?" (Slide 8)
/// Atende a: RF02, RF03, RNF01 (Decisão em até 3 cliques).
class TriageFeatureScreen extends StatelessWidget {
  final String category;

  const TriageFeatureScreen({super.key, required this.category});

  Future<void> _callEmergency() async {
    final uri = Uri.parse('tel:192');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final features = _getFeaturesForCategory(category);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passo 2 de 2: Características'),
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
                      'Qual característica você mais se lembra?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Selecione o detalhe mais marcante observado para ${categoryLabel(category)}:',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Lista de características visuais
                    ...[...features, {'label': 'Não lembro / não tenho certeza', 'speciesId': 'indeterminado'}].map((feature) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TriageResultScreen(
                                  speciesId: feature['speciesId'] as String,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.borderColor,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppTheme.primaryGreen,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    feature['label'] as String,
                                    style: const TextStyle(
                                      color: AppTheme.textLight,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: AppTheme.textMuted,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
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

  List<Map<String, String>> _getFeaturesForCategory(String cat) {
    if (cat.contains('Rep')) {
      return [
        {
          'label': 'Possui guizo / chocalho na ponta da cauda',
          'speciesId': 'esp-001',
        },
        {
          'label': 'Corpo com anéis coloridos (vermelho, preto, branco/amarelo)',
          'speciesId': 'esp-004',
        },
        {
          'label': 'Possui manchas escuras em forma de ferradura ou "V" invertido',
          'speciesId': 'esp-002',
        },
        {
          'label': 'Serpente muito grande em mata densa, escamas rugosas (pico-de-jaca)',
          'speciesId': 'esp-003',
        },
      ];
    } else if (cat.contains('Ará') || cat.contains('Ara')) {
      return [
        {
          'label': 'Escorpião de corpo amarelo e tronco escuro',
          'speciesId': 'esp-005',
        },
        {
          'label': 'Escorpião amarelo com triângulo escuro no dorso',
          'speciesId': 'esp-006',
        },
        {
          'label': 'Aranha agressiva que ergue as patas dianteiras em ataque',
          'speciesId': 'esp-007',
        },
        {
          'label': 'Aranha pequena escura com desenho vermelho na barriga',
          'speciesId': 'esp-008',
        },
      ];
    } else if (cat.contains('Anf')) {
      return [
        {
          'label': 'Sapo grande rugoso com bolsas volumosas atrás dos olhos',
          'speciesId': 'esp-011',
        },
        {
          'label': 'Pequena rã com coloração amarela ou dourada brilhante uniforme',
          'speciesId': 'esp-012',
        },
      ];
    } else {
      return [
        {
          'label': 'Lagarta peluda em árvore com cerdas ramificadas (pinheirinho)',
          'speciesId': 'esp-009',
        },
        {
          'label': 'Abelha listrada com ataque violento em enxame',
          'speciesId': 'esp-010',
        },
      ];
    }
  }
}
