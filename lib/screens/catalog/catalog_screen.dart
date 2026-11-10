import '../../services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/species.dart';
import '../../services/species_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/species_card.dart';
import 'filter_sheet.dart';
import 'species_detail_screen.dart';

/// Tela do Catálogo Visual de Espécies Peçonhentas.
/// Atende a: RF06, RF07, RF12, RNF02 (100% offline).
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Todas';
  String? _selectedDangerLevel;
  List<String> _selectedColors = [];

  final List<String> _categories = [
    'Todas',
    'Reptiles',
    'Arácnidos',
    'Anfibios',
    'Insectos',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSheet(
        initialDangerLevel: _selectedDangerLevel,
        initialColors: _selectedColors,
        onApply: (danger, colors) {
          setState(() {
            _selectedDangerLevel = danger;
            _selectedColors = colors;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final speciesService = Provider.of<SpeciesService>(context);

    final filteredList = speciesService.filterSpecies(
      query: _searchController.text,
      category: _selectedCategory,
      dangerLevel: _selectedDangerLevel,
      colors: _selectedColors,
    );

    final hasActiveAdvancedFilters =
        _selectedDangerLevel != null || _selectedColors.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Espécies'),
        actions: [
          IconButton(
            tooltip: 'Filtros Avançados',
            icon: Stack(
              children: [
                const Icon(Icons.filter_list, color: AppTheme.textLight),
                if (hasActiveAdvancedFilters)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _openFilterDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Barra de Busca
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Pesquisar por nome popular ou científico...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppTheme.textMuted),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            // Chips Horizontais de Categoria
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: AppTheme.primaryGreen,
                      backgroundColor: AppTheme.surfaceColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textLight,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppTheme.primaryGreen : AppTheme.borderColor,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Grid de Espécies
            Expanded(
              child: speciesService.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppTheme.primaryGreen),
                    )
                  : filteredList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off,
                                  size: 48, color: AppTheme.textMuted),
                              const SizedBox(height: 12),
                              const Text(
                                'Nenhuma espécie encontrada com esses filtros.',
                                style: TextStyle(color: AppTheme.textMuted),
                              ),
                              if (hasActiveAdvancedFilters ||
                                  _selectedCategory != 'Todas' ||
                                  _searchController.text.isNotEmpty)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _selectedCategory = 'Todas';
                                      _selectedDangerLevel = null;
                                      _selectedColors.clear();
                                    });
                                  },
                                  child: const Text('Limpar todos os filtros'),
                                ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final species = filteredList[index];
                            return SpeciesCard(
                              species: species,
                              onTap: () {
                                AnalyticsService().logSpeciesViewed(species.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SpeciesDetailScreen(
                                      species: species,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
