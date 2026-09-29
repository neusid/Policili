import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

enum SensorType {
  temperature,
  airHumidity,
  soilMoisture,
  ph,
  generic,
}

class SensorBentoCard extends StatelessWidget {
  const SensorBentoCard({
    super.key,
    required this.title,
    required this.value,
    this.unit = '',
    this.status = 'Optimal',
    this.type = SensorType.generic,
  });

  final String title;
  final String value;
  final String unit;
  final String status;
  final SensorType type;

  IconData _getIcon() {
    switch (type) {
      case SensorType.temperature:
        return Icons.thermostat_rounded;
      case SensorType.airHumidity:
        return Icons.water_drop_rounded;
      case SensorType.soilMoisture:
        return Icons.grass_rounded;
      case SensorType.ph:
        return Icons.science_rounded;
      case SensorType.generic:
        return Icons.sensors_rounded;
    }
  }

  Color _getColor() {
    switch (type) {
      case SensorType.temperature:
        return AppColors.tempColor;
      case SensorType.airHumidity:
        return AppColors.humidityColor;
      case SensorType.soilMoisture:
        return AppColors.soilColor;
      case SensorType.ph:
        return AppColors.phColor;
      case SensorType.generic:
        return AppColors.emerald;
    }
  }

  Color _getBgColor() {
    switch (type) {
      case SensorType.temperature:
        return AppColors.tempBg;
      case SensorType.airHumidity:
        return AppColors.humidityBg;
      case SensorType.soilMoisture:
        return AppColors.soilBg;
      case SensorType.ph:
        return AppColors.phBg;
      case SensorType.generic:
        return AppColors.emeraldSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final bgColor = _getBgColor();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Icon on left, Status chip on right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(_getIcon(), color: color, size: 20),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.emeraldSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.emerald.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.emeraldDark,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Label
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2),

          // Value and Unit
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
