import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toxid/widgets/species_photo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/occurrence.dart';
import '../../services/species_service.dart';
import '../../services/history_service.dart';
import '../../services/location_service.dart';
import '../../services/analytics_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_badge.dart';
import '../../widgets/first_aid_banner.dart';
import '../hospitals/hospitals_screen.dart';

/// Tela de Resultado da Triagem do Modo Emergência.
/// Conclui o fluxo em até 3 cliques (RNF01) e atende estritamente a:
/// - RF03: Identificação do animal
/// - RF04: Soro antiveneno em destaque
/// - RF08 & RF09: Instruções de primeiros socorros e alertas de contraindicações
/// - Requisito: "Implementar histórico local das identificações realizadas pelo usuário"
/// - Requisito: "Registrar a localização geográfica das ocorrências utilizando GPS"
/// - Requisito: "Implementar botão de emergência que compartilhe localização e informações da identificação"
/// - Requisito: "Compartilhar relatório da identificação em PDF"
/// - Requisito: "Implementar Firebase Analytics para registrar consultas realizadas"
class TriageResultScreen extends StatefulWidget {
  final String speciesId;

  const TriageResultScreen({super.key, required this.speciesId});

  @override
  State<TriageResultScreen> createState() => _TriageResultScreenState();
}

class _TriageResultScreenState extends State<TriageResultScreen> {
  final LocationService _locationService = LocationService();
  final AnalyticsService _analytics = AnalyticsService();
  Occurrence? _record;
  String _status = 'Consultando localização…';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _recordResult());
  }

  Future<void> _recordResult() async {
    if (!mounted) return;
    final species = context.read<SpeciesService>().getById(widget.speciesId);
    if (species == null) return;
    final history = context.read<HistoryService>();
    final pos = await _locationService.getCurrentPosition();
    if (!mounted) return;
    final now = DateTime.now();
    final record = Occurrence(id: 'occ-${now.microsecondsSinceEpoch}',
        timestamp: now, speciesId: species.id, speciesName: species.commonName,
        scientificName: species.scientificName, dangerLevel: species.dangerLevel,
        antivenom: species.antivenom, latitude: pos?.latitude, longitude: pos?.longitude);
    _analytics.logTriageCompleted(speciesId: species.id, speciesName: species.commonName,
        antivenom: species.antivenom);
    try {
      await history.addOccurrence(record);
      _status = 'Salvo no histórico • ${record.locationText}';
    } catch (_) {
      _status = 'Não foi possível salvar no dispositivo • ${record.locationText}';
    }
    if (mounted) setState(() => _record = record);
  }

  Future<void> _callEmergency() async {
    if (!await launchUrl(Uri.parse('tel:192')) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Discador indisponível. SAMU: 192.')));
    }
  }

  Future<void> _shareEmergencyAlert(String name, String scientific, String serum, String danger) async {
    final text = _record?.generateEmergencyShareText() ??
        'Alerta ToxID • identificação preliminar: $name ($scientific). Localização indisponível.';
    await Share.share(text);
  }

  Future<void> _showPdfReportDialog(String name, String scientific, String serum) async {
    final document = pw.Document();
    document.addPage(pw.Page(build: (_) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Header(text: 'ToxID - Relatório de identificação'),
        pw.Text('Identificação visual preliminar: $name ($scientific)'),
        pw.Text('Data: ${_record?.timestamp.toLocal() ?? DateTime.now()}'),
        pw.Text(_record?.locationText ?? 'Localização indisponível'),
        pw.Text('Referência do catálogo: $serum'),
      ])));
    await Printing.sharePdf(bytes: await document.save(), filename: 'ToxID-identificacao.pdf');
  }

  @override
  Widget build(BuildContext context) {
    final speciesService = Provider.of<SpeciesService>(context);
    final species = speciesService.getById(widget.speciesId);

    if (species == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resultado')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 54, color: AppTheme.alertRed),
              const SizedBox(height: 12),
              const Text('Falha na identificação do animal.', style: TextStyle(color: AppTheme.textLight, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text('Não foi possível identificar com certeza a espécie. Procure um hospital de referência imediatamente.',
                    textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _callEmergency,
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.emergencyRed),
                child: const Text('Ligar SAMU 192', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Identificação preliminar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: AppTheme.lightGreen),
            tooltip: 'Gerar Relatório em PDF',
            onPressed: () => _showPdfReportDialog(
              species.commonName,
              species.scientificName,
              species.antivenom,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ],
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
                    // Imagem destacada do animal
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 200,
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

                    const SizedBox(height: 14),

                    // Badge de salvo no histórico com GPS
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, size: 14, color: AppTheme.primaryGreen),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _status,
                              style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ==========================================
                    // CARD DESTACADO: SORO INDICADO (RF04)
                    // ==========================================
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
                                'SORO ANTIVENENO INDICADO',
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
                              fontSize: 18,
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
                                'Localizar Hospital Mais Próximo',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ============================================================
                    // BOTÃO: COMPARTILHAR EMERGÊNCIA COM LOCALIZAÇÃO GPS (NOVO)
                    // ============================================================
                    OutlinedButton.icon(
                      onPressed: () => _shareEmergencyAlert(
                        species.commonName,
                        species.scientificName,
                        species.antivenom,
                        species.dangerLevel,
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.alertRed, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.share_location, color: AppTheme.alertRed, size: 20),
                      label: const Text(
                        'Compartilhar Alerta com GPS',
                        style: TextStyle(color: AppTheme.alertRed, fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==========================================
                    // ALERTAS DE PRIMEIROS SOCORROS (RF08, RF09)
                    // ==========================================
                    FirstAidBanner(
                      doList: species.firstAidDo,
                      dontList: species.firstAidDont,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Botão Fixo de Emergência (SAMU 192)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.darkBackground,
                border: Border(top: BorderSide(color: AppTheme.borderColor)),
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
}
