import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/occurrence.dart';
import '../../services/history_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_badge.dart';

/// Tela de Histórico Local de Identificações com Status de Sincronização.
/// Atende a:
/// - "Implementar histórico local das identificações realizadas pelo usuário"
/// - "Registrar a localização geográfica das ocorrências utilizando GPS"
/// - "Sincronizar automaticamente os dados locais com o Firebase quando a conexão for restabelecida"
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyService = Provider.of<HistoryService>(context);
    final occurrences = historyService.occurrences;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Identificações'),
        actions: [
          IconButton(
            tooltip: 'Sincronizar com Firebase',
            icon: historyService.isSyncing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(color: AppTheme.primaryGreen, strokeWidth: 2),
                  )
                : const Icon(Icons.sync, color: AppTheme.primaryGreen),
            onPressed: () => historyService.syncWithFirebase(),
          ),
        ],
      ),
      body: SafeArea(
        child: occurrences.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.history_toggle_off, size: 64, color: AppTheme.textMuted),
                    SizedBox(height: 16),
                    Text(
                      'Nenhuma identificação registrada ainda.',
                      style: TextStyle(color: AppTheme.textLight, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'As identificações feitas no Modo Emergência serão salvas aqui.',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: occurrences.length,
                itemBuilder: (context, index) {
                  final occ = occurrences[index];
                  final dateFormatted =
                      '${occ.timestamp.day.toString().padLeft(2, '0')}/${occ.timestamp.month.toString().padLeft(2, '0')}/${occ.timestamp.year} às ${occ.timestamp.hour.toString().padLeft(2, '0')}:${occ.timestamp.minute.toString().padLeft(2, '0')}';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                occ.speciesName,
                                style: const TextStyle(
                                  color: AppTheme.textLight,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DangerBadge(dangerLevel: occ.dangerLevel, isSmall: true),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          occ.scientificName,
                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.vaccines, size: 16, color: AppTheme.primaryGreen),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Soro: ${occ.antivenom}',
                                  style: const TextStyle(color: AppTheme.lightGreen, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textMuted),
                            const SizedBox(width: 4),
                            Text(
                              occ.locationText,
                              style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                            ),
                            const Spacer(),
                            // Status de sincronização
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: occ.synced
                                    ? AppTheme.primaryGreen.withOpacity(0.15)
                                    : AppTheme.warningOrange.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: occ.synced ? AppTheme.primaryGreen : AppTheme.warningOrange,
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    occ.synced ? Icons.cloud_done : Icons.cloud_queue,
                                    size: 12,
                                    color: occ.synced ? AppTheme.primaryGreen : AppTheme.warningOrange,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    occ.synced ? 'Sincronizado' : 'Offline / Local',
                                    style: TextStyle(
                                      color: occ.synced ? AppTheme.primaryGreen : AppTheme.warningOrange,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dateFormatted,
                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
