import 'package:flutter/material.dart';
import '../domain/species_labels.dart';

/// Badge visual para exibição do nível de periculosidade da espécie.
class DangerBadge extends StatelessWidget {
  final String dangerLevel;
  final bool isSmall;

  const DangerBadge({
    super.key,
    required this.dangerLevel,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor = Colors.white;

    final label = dangerLabel(dangerLevel);
    if (label == 'Muito perigosa') {
      bgColor = const Color(0xFFC0392B);
    } else if (label == 'Perigosa') {
      bgColor = const Color(0xFFD35400);
    } else if (label == 'Baixo perigo') {
      bgColor = const Color(0xFF27AE60);
    } else {
      bgColor = const Color(0xFF7F8C8D);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bgColor, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: isSmall ? 10 : 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
