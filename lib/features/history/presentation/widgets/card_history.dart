import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';

class CardHistory extends StatelessWidget {
  final String imageUrl;
  final String plantName;
  final String date;
  final String soilMoisture;
  final String airMoisture;
  final String ph;
  final String temperature;

  const CardHistory({
    super.key,
    required this.imageUrl,
    required this.plantName,
    required this.date,
    required this.soilMoisture,
    required this.airMoisture,
    required this.ph,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Plant Name & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  plantName,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.cardHeader,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  DateFormatter.formatIndonesianDateTime(date),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Symmetrical Divider
          Container(
            height: 1,
            color: AppColors.cardBorder.withValues(alpha: 0.6),
          ),

          const SizedBox(height: 12),

          // Body Row: Thumbnail on left, Sensor metrics on right
          Row(
            children: [
              // Plant Thumbnail
              Container(
                width: 58,
                height: 58,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: (imageUrl.startsWith('http'))
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Image.asset(
                          "assets/img/mascot.png",
                          fit: BoxFit.contain,
                        ),
                      )
                    : Image.asset(
                        "assets/img/mascot.png",
                        fit: BoxFit.contain,
                      ),
              ),

              const SizedBox(width: 14),

              // 2 Symmetrical Columns of Metrics
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMetricItem(
                            icon: Icons.grass_rounded,
                            iconColor: AppColors.soilColor,
                            label: "Tanah",
                            value: soilMoisture.contains('%')
                                ? soilMoisture
                                : '$soilMoisture%',
                          ),
                          const SizedBox(height: 6),
                          _buildMetricItem(
                            icon: Icons.water_drop_rounded,
                            iconColor: AppColors.humidityColor,
                            label: "Udara",
                            value: airMoisture.contains('%')
                                ? airMoisture
                                : '$airMoisture%',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMetricItem(
                            icon: Icons.science_rounded,
                            iconColor: AppColors.phColor,
                            label: "pH",
                            value: ph,
                          ),
                          const SizedBox(height: 6),
                          _buildMetricItem(
                            icon: Icons.thermostat_rounded,
                            iconColor: AppColors.tempColor,
                            label: "Suhu",
                            value: temperature.contains('°C')
                                ? temperature
                                : '$temperature°C',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 4),
        Text(
          "$label: ",
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.textMuted,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
