import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/hospital.dart';
import '../theme/app_theme.dart';

/// Card de exibição de hospital de referência com distância e discagem rápida.
class HospitalCard extends StatelessWidget {
  final Hospital hospital;
  final double? userLat;
  final double? userLng;
  final VoidCallback? onRoute, onNavigate;

  const HospitalCard({
    super.key,
    required this.hospital,
    required this.userLat,
    required this.userLng,
    this.onRoute,
    this.onNavigate,
  });

  Future<void> _makeCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final distanceKm = userLat == null || userLng == null
        ? null
        : hospital.distanceFrom(userLat!, userLng!);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceHighlight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: const Icon(
                  Icons.local_hospital,
                  color: AppTheme.primaryGreen,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital.name,
                      style: const TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${hospital.city} - ${hospital.state}',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hospital.address,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Distância e contato mantêm o visual do cartão.
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Badge de Distância
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceHighlight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.near_me,
                      size: 14,
                      color: AppTheme.lightGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      distanceKm == null
                          ? 'Sem GPS'
                          : '${distanceKm.toStringAsFixed(1)} km em linha reta',
                      style: const TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Badge de Tempo Estimado
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceHighlight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: AppTheme.cautionYellow,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Ver rota',
                      style: const TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Botão de Discagem Rápida
              ElevatedButton.icon(
                onPressed: () => _makeCall(hospital.phone),
                icon: const Icon(Icons.phone, size: 16, color: Colors.white),
                label: const Text(
                  'Ligar',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.callGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),

          if (onRoute != null || onNavigate != null)
            Wrap(
              spacing: 8,
              children: [
                if (onRoute != null)
                  TextButton.icon(
                    onPressed: onRoute,
                    icon: const Icon(Icons.alt_route),
                    label: const Text('Traçar rota'),
                  ),
                if (onNavigate != null)
                  TextButton.icon(
                    onPressed: onNavigate,
                    icon: const Icon(Icons.navigation),
                    label: const Text('Abrir navegação'),
                  ),
              ],
            ),
          const Text(
            'Disponibilidade de soros não confirmada.',
            style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
          ),
          if (hospital.availableSerums.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: hospital.availableSerums.map((serum) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.mutedGreen.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primaryGreen.withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    'Cadastro: $serum',
                    style: const TextStyle(
                      color: AppTheme.lightGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
