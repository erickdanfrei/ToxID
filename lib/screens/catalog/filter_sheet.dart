import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Modal de Filtros Avançados por Nível de Perigosidade e Cores.
/// Atende ao RF07 e reproduz o slide 9 do protótipo.
class FilterSheet extends StatefulWidget {
  final String? initialDangerLevel;
  final List<String> initialColors;
  final Function(String? dangerLevel, List<String> colors) onApply;

  const FilterSheet({
    super.key,
    this.initialDangerLevel,
    required this.initialColors,
    required this.onApply,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  String? _selectedDanger;
  late List<String> _selectedColors;

  final List<String> _dangerLevels = [
    'Muy Peligrosa',
    'Peligrosa',
    'Bajo Peligro',
    'No Peligrosa',
  ];

  final List<String> _availableColors = [
    'Negro',
    'Rojizo',
    'Amarillo',
    'Marrón',
    'Naranja',
    'Blanco',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDanger = widget.initialDangerLevel;
    _selectedColors = List.from(widget.initialColors);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtros',
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedDanger = null;
                      _selectedColors.clear();
                    });
                  },
                  child: const Text('Limpar', style: TextStyle(color: AppTheme.alertRed)),
                ),
              ],
            ),
            const Divider(color: AppTheme.borderColor),
            const SizedBox(height: 12),

            // Nível de Periculosidade
            const Text(
              'Nível de Perigo:',
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _dangerLevels.map((danger) {
                final isSelected = _selectedDanger == danger;
                return ChoiceChip(
                  label: Text(danger),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryGreen.withOpacity(0.3),
                  backgroundColor: AppTheme.cardColor,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primaryGreen : AppTheme.textLight,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppTheme.primaryGreen : AppTheme.borderColor,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedDanger = selected ? danger : null;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Filtro por Cor
            const Text(
              'Cor Predominante:',
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableColors.map((color) {
                final isSelected = _selectedColors.contains(color);
                return FilterChip(
                  label: Text(color),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryGreen.withOpacity(0.3),
                  backgroundColor: AppTheme.cardColor,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primaryGreen : AppTheme.textLight,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppTheme.primaryGreen : AppTheme.borderColor,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedColors.add(color);
                      } else {
                        _selectedColors.remove(color);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            ElevatedButton(
              onPressed: () {
                widget.onApply(_selectedDanger, _selectedColors);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
              ),
              child: const Text('Aplicar Filtros', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
