import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/policili_button.dart';
import '../../../../core/widgets/sensor_bento_card.dart';
import 'package:policili_apps/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:policili_apps/features/auth/presentation/bloc/auth_state.dart';
import '../bloc/recommendation_bloc.dart';
import '../bloc/recommendation_event.dart';
import '../bloc/recommendation_state.dart';

class GeneratePage extends StatefulWidget {
  const GeneratePage({super.key});

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _userEmail = authState.user.email;
    }
  }

  void _onRefresh() {
    context
        .read<RecommendationBloc>()
        .add(RefreshRecommendationEvent(_userEmail));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecommendationBloc, RecommendationState>(
      listener: (context, state) {
        if (state is RecommendationFailure) {
          UiHelpers.showSnackBar(
            context,
            title: 'Gagal Memperbarui',
            message: state.errorMessage,
            isError: true,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RecommendationLoading;

        if (state is! RecommendationLoaded && !isLoading) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text("Hasil Rekomendasi"),
              centerTitle: true,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/img/mascot.png", width: 110),
                    const SizedBox(height: 20),
                    Text(
                      'Belum ada data rekomendasi',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    PoliciliButton(
                      text: 'Kembali ke Beranda',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final result = state is RecommendationLoaded ? state.result : null;
        final plant = result?.plantDetails;
        final sensor = result?.sensorData;
        final alternatives = result?.alternativeCrops ?? [];

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Text(
              "Hasil Rekomendasi",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 18),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                tooltip: "Muat Ulang",
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                onPressed: isLoading ? null : _onRefresh,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Stack(
            children: [
              if (result != null)
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recommended Crop Hero Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: AppColors.cardBorder),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Symmetrical Plant Thumbnail Container
                                Container(
                                  width: 120,
                                  height: 120,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight.withValues(alpha: 0.5),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primary.withValues(alpha: 0.15),
                                      width: 2,
                                    ),
                                  ),
                                  child: (plant != null && plant.url.isNotEmpty)
                                      ? Image.network(
                                          "${ApiConstants.meepLabImageBaseUrl}/${plant.url}",
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

                                const SizedBox(height: 16),

                                // Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.emeraldSurface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.emerald.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.verified_rounded,
                                        size: 14,
                                        color: AppColors.emeraldDark,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Rekomendasi Utama",
                                        style: GoogleFonts.inter(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.emeraldDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  plant?.name ?? result.primaryCropName,
                                  style: GoogleFonts.inter(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 12),

                                // Symmetrical Divider
                                Container(
                                  height: 1,
                                  color: AppColors.cardBorder,
                                ),

                                const SizedBox(height: 14),

                                Text(
                                  plant?.kelebihan ??
                                      "Varietas ini memiliki tingkat adaptasi yang sangat tinggi terhadap karakteristik tanah dan iklim lahan Anda.",
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Alternatif Varietas
                          if (alternatives.isNotEmpty) ...[
                            Text(
                              "Alternatif Varietas Potensial",
                              style: GoogleFonts.inter(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: alternatives.map((alt) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: AppColors.cardBorder),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.02),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.eco_outlined,
                                        size: 15,
                                        color: AppColors.emerald,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        alt,
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Symmetrical Telemetri Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Telemetri Sensor Lahan Real-Time",
                                style: GoogleFonts.inter(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                "Thinger.io Node",
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Symmetrical 2x2 Bento Grid
                          GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.18,
                            children: [
                              SensorBentoCard(
                                title: "Suhu Udara",
                                value: sensor?.suhu ?? "28",
                                unit: "°C",
                                status: "Normal",
                                type: SensorType.temperature,
                              ),
                              SensorBentoCard(
                                title: "Kelembaban Udara",
                                value: sensor?.humidity ?? "65",
                                unit: "%",
                                status: "Optimal",
                                type: SensorType.airHumidity,
                              ),
                              SensorBentoCard(
                                title: "Kelembaban Tanah",
                                value: sensor?.soilMoisture ?? "45",
                                unit: "%",
                                status: "Optimal",
                                type: SensorType.soilMoisture,
                              ),
                              SensorBentoCard(
                                title: "Kadar pH Tanah",
                                value: sensor?.ph ?? "6.5",
                                unit: "pH",
                                status: "Seimbang",
                                type: SensorType.ph,
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // Actions
                          PoliciliButton(
                            text: "Perbarui Data Sensor",
                            icon: const Icon(
                              Icons.sync_rounded,
                              color: Colors.white,
                              size: 19,
                            ),
                            isLoading: isLoading,
                            onPressed: isLoading ? null : _onRefresh,
                          ),
                          const SizedBox(height: 12),
                          PoliciliButton(
                            text: "Kembali ke Beranda",
                            isOutlined: true,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Smooth Loading Overlay
              if (isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.35),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Menghubungkan Sensor...",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Menganalisis parameter telemetri tanah",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
