import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/species.dart';
import '../../models/hospital.dart';
import '../../services/auth_service.dart';
import '../../services/species_service.dart';
import '../../services/hospital_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_badge.dart';
import 'species_form_screen.dart';
import 'hospital_form_screen.dart';

/// Painel Administrativo de Gestão do ToxID.
/// Reproduz fielmente a tela do Slide 10:
/// - Abas: "Especies" e "Hospitales"
/// - Botões "+ Agregar Especie" e "+ Agregar Hospital"
/// - Operações completas de CRUD (Create, Read, Update, Delete)
class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _currentTab = 0; // 0: Especies, 1: Hospitales

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    if (!authService.isAdmin) return const Scaffold(body: Center(child: Text("Acesso administrativo necessário.")));
    final speciesService = Provider.of<SpeciesService>(context);
    final hospitalService = Provider.of<HospitalService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Administrativo'),
        actions: [
          IconButton(
            tooltip: 'Sair do Modo Admin',
            icon: const Icon(Icons.logout, color: AppTheme.alertRed),
            onPressed: () async {
              await authService.signOut();
              if (mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho de Metadados (como no Slide 10)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: AppTheme.surfaceColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Gestão de Registros',
                    style: TextStyle(
                      color: AppTheme.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Última Atualização: 29/09/2026',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Seletor de Abas (Especies / Hospitales)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _currentTab = 0),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _currentTab == 0
                                ? AppTheme.primaryGreen.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: _currentTab == 0
                                ? Border.all(color: AppTheme.primaryGreen)
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bug_report,
                                size: 18,
                                color: _currentTab == 0
                                    ? AppTheme.primaryGreen
                                    : AppTheme.textMuted,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Espécies (${speciesService.speciesList.length})',
                                style: TextStyle(
                                  color: _currentTab == 0
                                      ? AppTheme.textLight
                                      : AppTheme.textMuted,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _currentTab = 1),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _currentTab == 1
                                ? AppTheme.primaryGreen.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: _currentTab == 1
                                ? Border.all(color: AppTheme.primaryGreen)
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_hospital,
                                size: 18,
                                color: _currentTab == 1
                                    ? AppTheme.primaryGreen
                                    : AppTheme.textMuted,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Hospitais (${hospitalService.hospitals.length})',
                                style: TextStyle(
                                  color: _currentTab == 1
                                      ? AppTheme.textLight
                                      : AppTheme.textMuted,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Conteúdo da Aba
            Expanded(
              child: _currentTab == 0
                  ? _buildSpeciesTab(speciesService)
                  : _buildHospitalsTab(hospitalService),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeciesTab(SpeciesService service) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Listagem de Espécies',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SpeciesFormScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text('+ Adicionar Espécie',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
            ],
          ),
        ),
        const Divider(color: AppTheme.borderColor),
        Expanded(
          child: SingleChildScrollView(child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(columns: const [DataColumn(label: Text('Espécie')), DataColumn(label: Text('Categoria')), DataColumn(label: Text('Risco')), DataColumn(label: Text('Ações'))],
              rows: service.speciesList.map((item) => DataRow(cells: [
                DataCell(Text(item.commonName)), DataCell(Text(item.category)), DataCell(Text(item.dangerLevel)),
                DataCell(Row(children: [
                  IconButton(tooltip: 'Editar', icon: const Icon(Icons.edit), onPressed: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SpeciesFormScreen(speciesToEdit: item)))),
                  IconButton(tooltip: 'Excluir', icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDeleteSpecies(context, service, item)),
                ])),
              ])).toList()),
          )),
        ),
      ],
    );
  }

  Widget _buildHospitalsTab(HospitalService service) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Listagem de Hospitais',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HospitalFormScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text('+ Adicionar Hospital',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
            ],
          ),
        ),
        const Divider(color: AppTheme.borderColor),
        Expanded(
          child: SingleChildScrollView(child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(columns: const [DataColumn(label: Text('Hospital')), DataColumn(label: Text('Cidade')), DataColumn(label: Text('UF')), DataColumn(label: Text('Ações'))],
              rows: service.hospitals.map((item) => DataRow(cells: [
                DataCell(Text(item.name)), DataCell(Text(item.city)), DataCell(Text(item.state)),
                DataCell(Row(children: [
                  IconButton(tooltip: 'Editar', icon: const Icon(Icons.edit), onPressed: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (_) => HospitalFormScreen(hospitalToEdit: item)))),
                  IconButton(tooltip: 'Excluir', icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDeleteHospital(context, service, item)),
                ])),
              ])).toList()),
          )),
        ),
      ],
    );
  }

  void _confirmDeleteSpecies(BuildContext context, SpeciesService service, Species s) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('Excluir Espécie?', style: TextStyle(color: AppTheme.textLight)),
        content: Text(
          'Deseja realmente remover permanentemente a espécie "${s.commonName}"?',
          style: const TextStyle(color: AppTheme.textMuted),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.alertRed),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Navigator.pop(ctx);
              await service.deleteSpecies(s.id);
            },
          ),
        ],
      ),
    );
  }

  void _confirmDeleteHospital(BuildContext context, HospitalService service, Hospital h) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('Excluir Hospital?', style: TextStyle(color: AppTheme.textLight)),
        content: Text(
          'Deseja realmente remover o hospital "${h.name}"?',
          style: const TextStyle(color: AppTheme.textMuted),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.alertRed),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Navigator.pop(ctx);
              await service.deleteHospital(h.id);
            },
          ),
        ],
      ),
    );
  }
}
