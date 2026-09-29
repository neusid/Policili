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
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      padding: const EdgeInsets.all(18),
                      decoration: const BoxDecoration(
                        color: AppColors.emeraldSurface,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset("assets/img/mascot.png"),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Belum Ada Rekomendasi',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Data telemetri sensor belum diproses atau sesi telah berakhir.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
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
            title: Text(
              "Hasil Rekomendasi AI",
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
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 18),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                tooltip: "Muat Ulang Data Sensor",
                icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
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
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hero Crop Card
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppColors.cardBorder),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Top Hero Banner
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: const BoxDecoration(
                                    color: AppColors.emeraldSurface,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(23),
                                      topRight: Radius.circular(23),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.verified_rounded,
                                            size: 16,
                                            color: AppColors.emeraldDark,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "Rekomendasi Paling Cocok",
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.emeraldDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "Tingkat Cocok: 96%",
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.emeraldDark,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Plant Image / Mascot
                                const SizedBox(height: 20),
                                Container(
                                  width: 140,
                                  height: 140,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight.withValues(alpha: 0.4),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.12),
                                        blurRadius: 20,
                                        spreadRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: (plant != null && plant.url.isNotEmpty)
                                      ? Image.network(
                                          "${ApiConstants.meepLabImageBaseUrl}/${plant.url}",
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) =>
                                              Image.asset(
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

                                // Crop Name
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    plant?.name ?? result.primaryCropName,
                                    style: GoogleFonts.inter(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Manfaat & Karakteristik Card
                                Container(
                                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.cardBorder,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.emeraldSurface,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.eco_rounded,
                                          size: 20,
                                          color: AppColors.emeraldDark,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Karakteristik & Manfaat",
                                              style: GoogleFonts.inter(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              plant?.kelebihan ??
                                                  "Tanaman sangat cocok dibudidayakan pada parameter tanah dan iklim saat ini.",
                                              style: GoogleFonts.inter(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.textSecondary,
                                                height: 1.45,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Alternatif Tanaman Section
                          if (alternatives.isNotEmpty) ...[
                            Text(
                              "Alternatif Varietas Tanaman",
                              style: GoogleFonts.inter(
                                fontSize: 15,
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
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: AppColors.cardBorder),
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
                                        Icons.check_circle_rounded,
                                        size: 14,
                                        color: AppColors.emerald,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        alt,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
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

                          // Section Title: Telemetri Sensor 2x2 Bento
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Telemetri Sensor IoT Real-time",
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                "Thinger.io Node",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // 2x2 Bento Grid
                          GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.25,
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
                          const SizedBox(height: 30),

                          // Bottom Actions
                          PoliciliButton(
                            text: "Perbarui Data Sensor",
                            icon: const Icon(
                              Icons.sync_rounded,
                              color: Colors.white,
                              size: 20,
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
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.5,
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
