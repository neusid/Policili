import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import '../../../../app/config/routes/app_routes.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/ui_helpers.dart';
import 'package:policili_apps/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:policili_apps/features/auth/presentation/bloc/auth_state.dart';
import '../bloc/recommendation_bloc.dart';
import '../bloc/recommendation_event.dart';
import '../bloc/recommendation_state.dart';
import '../widgets/card_device.dart';

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
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/img/mascot.png", width: 100.w),
                    SizedBox(height: 20.h),
                    Text(
                      'Belum ada data rekomendasi',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFF2020),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Kembali ke Beranda', style: TextStyle(color: Colors.white)),
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
          extendBody: true,
          body: Stack(
            children: [
              // Signature Mesh Gradient Background
              Positioned.fill(
                child: AnimatedMeshGradient(
                  colors: const [
                    Color(0xffFFE4D0),
                    Color(0xffFDE6E7),
                    Color(0xffFFE4ff),
                    Color(0xffFCD8DA),
                  ],
                  options: AnimatedMeshGradientOptions(
                    speed: 0.04,
                    frequency: 6,
                    amplitude: 28,
                    grain: 0.08,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),

              if (result != null)
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 90.h),
                  child: Column(
                    children: [
                      // Header Card with bg_card.png
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 340.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20.w),
                                bottomLeft: Radius.circular(20.w),
                              ),
                              image: const DecorationImage(
                                image: AssetImage("assets/img/bg_card.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Back button
                          SafeArea(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  width: 44.w,
                                  height: 44.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.08),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.arrow_back_rounded, color: Color(0xff1E293B)),
                                ),
                              ),
                            ),
                          ),

                          // Floating Mascot & Crop Name
                          Positioned(
                            top: 60.h,
                            left: 0,
                            right: 0,
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 140.w,
                                      height: 140.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.35),
                                            blurRadius: 30,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    (plant != null && plant.url.isNotEmpty)
                                        ? Image.network(
                                            "${ApiConstants.meepLabImageBaseUrl}/${plant.url}",
                                            width: 160.w,
                                            height: 160.w,
                                            fit: BoxFit.contain,
                                            errorBuilder: (_, __, ___) => Image.asset(
                                              "assets/img/mascot.png",
                                              width: 160.w,
                                              fit: BoxFit.contain,
                                            ),
                                          )
                                        : Image.asset(
                                            "assets/img/mascot.png",
                                            width: 160.w,
                                            fit: BoxFit.contain,
                                          ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Text(
                                    plant?.name ?? result.primaryCropName,
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // "Manfaat" Card overlaying the bottom edge of the red header
                          Positioned(
                            bottom: 12.h,
                            left: 20.w,
                            right: 20.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/img/search.png",
                                    width: 32.w,
                                    height: 32.w,
                                  ),
                                  SizedBox(width: 14.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Manfaat",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.5.sp,
                                            color: const Color(0xff0F172A),
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          plant?.kelebihan ??
                                              "Tanaman cocok dibudidayakan pada parameter tanah saat ini.",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                            color: const Color(0xff475569),
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 14.h),

                      // Alternatif & Telemetry Cards
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            // "Alternatif" Card with list.png
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/img/list.png",
                                    width: 32.w,
                                    height: 32.w,
                                  ),
                                  SizedBox(width: 14.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Alternatif",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.5.sp,
                                            color: const Color(0xff0F172A),
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        for (final alt in alternatives)
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 2.h),
                                            child: Text(
                                              "• $alt",
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.sp,
                                                color: const Color(0xff334155),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 14.h),

                            // 4 Device Cards
                            CardDevice(
                              logo: "Mm",
                              labelName: "Temprature",
                              labelValue: "${sensor?.suhu ?? '28.4'} °C",
                              status: "Success",
                            ),
                            CardDevice(
                              logo: "Mm",
                              labelName: "Air Humidity",
                              labelValue: "${sensor?.humidity ?? '72'} %",
                              status: "Success",
                            ),
                            CardDevice(
                              logo: "Mm",
                              labelName: "Soil Humidity",
                              labelValue: "${sensor?.soilMoisture ?? '65'} %",
                              status: "Success",
                            ),
                            CardDevice(
                              logo: "Mm",
                              labelName: "PH",
                              labelValue: sensor?.ph ?? "6.6",
                              status: "Success",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Loading Overlay
              if (isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.45),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LoadingAnimationWidget.fourRotatingDots(
                            color: const Color(0xffFF2020),
                            size: 44.w,
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            "Memperbarui data...",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff334155),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Authentic CurvedNavigationBar
          bottomNavigationBar: CurvedNavigationBar(
            index: 1,
            backgroundColor: Colors.transparent,
            buttonBackgroundColor: const Color(0xffFD9A37),
            color: Colors.white,
            height: 56.h,
            animationDuration: const Duration(milliseconds: 300),
            items: [
              Icon(Icons.home_rounded, size: 26.w, color: const Color(0xff6A0606)),
              Icon(Icons.refresh_rounded, size: 26.w, color: Colors.white),
              Icon(Icons.settings_suggest_outlined, color: Colors.grey.shade600, size: 26.w),
            ],
            onTap: (index) {
              if (index == 0) {
                Navigator.of(context).pop();
              } else if (index == 1) {
                context
                    .read<RecommendationBloc>()
                    .add(RefreshRecommendationEvent(_userEmail));
              } else if (index == 2) {
                Navigator.of(context).pushNamed(AppRoutes.changeProfile);
              }
            },
          ),
        );
      },
    );
  }
}
