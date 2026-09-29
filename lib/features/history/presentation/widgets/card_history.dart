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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Date & Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xffF8FAFC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(19),
                topRight: Radius.circular(19),
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.cardBorder, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormatter.formatIndonesianDateTime(date),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.emerald.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "Terverifikasi AI",
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.emeraldDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body: Plant info & Telemetry Grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: imageUrl.startsWith('http')
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Image.asset(
                                "assets/img/mascot.png",
                              ),
                            )
                          : Image.asset(
                              "assets/img/mascot.png",
                              fit: BoxFit.contain,
                            ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rekomendasi Tanaman",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            plantName,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.cardBorder),
                const SizedBox(height: 14),

                // 4 Sensor Mini Pills
                Row(
                  children: [
                    Expanded(
                      child: _buildSensorItem(
                        icon: Icons.thermostat_rounded,
                        color: AppColors.tempColor,
                        bgColor: AppColors.tempBg,
                        label: "Suhu",
                        value: "$temperature°C",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSensorItem(
                        icon: Icons.science_rounded,
                        color: AppColors.phColor,
                        bgColor: AppColors.phBg,
                        label: "pH",
                        value: ph,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildSensorItem(
                        icon: Icons.water_drop_rounded,
                        color: AppColors.humidityColor,
                        bgColor: AppColors.humidityBg,
                        label: "Udara",
                        value: "$airMoisture%",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSensorItem(
                        icon: Icons.grass_rounded,
                        color: AppColors.soilColor,
                        bgColor: AppColors.soilBg,
                        label: "Tanah",
                        value: "$soilMoisture%",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorItem({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            "$label: ",
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
