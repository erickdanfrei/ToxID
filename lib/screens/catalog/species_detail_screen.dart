import 'package:toxid/widgets/species_photo.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/species.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_badge.dart';
import '../../widgets/first_aid_banner.dart';
import '../hospitals/hospitals_screen.dart';

/// Tela de Detalhamento da Espécie.
/// Atende a:
/// - RF04: Indicação destacada do soro antiveneno
/// - RF08 & RF09: Instruções de primeiros socorros e alertas de contraindicação
/// - RF10: Nome científico e detalhamento taxonômico
/// - RF11: Discagem de emergência via tel:
class SpeciesDetailScreen extends StatelessWidget {
  final Species species;

  const SpeciesDetailScreen({super.key, required this.species});

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
        title: Text(species.commonName),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Imagem da espécie
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 220,
                        color: AppTheme.surfaceHighlight,
                        child: SpeciesPhoto(species: species),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Título e Nível de Perigo
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                species.commonName,
                                style: const TextStyle(
                                  color: AppTheme.textLight,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                species.scientificName,
                                style: const TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DangerBadge(dangerLevel: species.dangerLevel),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Card de Soro Indicado
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.mutedGreen.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.primaryGreen, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.vaccines, color: AppTheme.primaryGreen, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'SORO ANTIVENENO ESPECÍFICO',
                                style: TextStyle(
                                  color: AppTheme.primaryGreen,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            species.antivenom,
                            style: const TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HospitalsScreen(
                                      requiredSerum: species.antivenom,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD35400),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: const Icon(Icons.location_on, color: Colors.white, size: 18),
                              label: const Text(
                                'Ver Hospitais com este Soro',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Instruções de Primeiros Socorros
                    FirstAidBanner(
                      doList: species.firstAidDo,
                      dontList: species.firstAidDont,
                    ),

                    const SizedBox(height: 20),

                    // Ficha Taxonômica e Biológica (RF10)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Detalhamento Taxonômico e Biológico',
                            style: TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(color: AppTheme.borderColor),
                          _buildDetailRow('Classe/Categoria', species.category),
                          _buildDetailRow('Nome Científico', species.scientificName, isItalic: true),
                          if (species.distribution.isNotEmpty)
                            _buildDetailRow('Distribuição Geográfica', species.distribution),
                          if (species.colors.isNotEmpty)
                            _buildDetailRow('Cores Observadas', species.colors.join(', ')),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Descrição
                    if (species.description.isNotEmpty) ...[
                      const Text(
                        'Descrição Médica e Comportamental',
                        style: TextStyle(
                          color: AppTheme.textLight,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        species.description,
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
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

  Widget _buildDetailRow(String label, String value, {bool isItalic = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
