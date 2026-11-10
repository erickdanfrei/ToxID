import 'package:toxid/widgets/species_photo.dart';
import 'package:flutter/material.dart';
import '../models/species.dart';
import '../theme/app_theme.dart';
import 'custom_badge.dart';

/// Card para exibição de espécies no catálogo e na listagem.
class SpeciesCard extends StatelessWidget {
  final Species species;
  final VoidCallback onTap;

  const SpeciesCard({
    super.key,
    required this.species,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem da espécie com placeholder seguro
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: AppTheme.surfaceHighlight,
                      child: SpeciesPhoto(species: species),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: DangerBadge(
                      dangerLevel: species.dangerLevel,
                      isSmall: true,
                    ),
                  ),
                ],
              ),
            ),

            // Informações de texto
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      species.commonName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      species.scientificName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('rep')) return Icons.pest_control;
    if (cat.contains('ará') || cat.contains('ara')) return Icons.bug_report;
    if (cat.contains('anf')) return Icons.water_drop;
    return Icons.coronavirus;
  }
}
