import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import '../../../../app/config/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/ui_helpers.dart';
import 'package:policili_apps/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:policili_apps/features/auth/presentation/bloc/auth_event.dart';
import 'package:policili_apps/features/auth/presentation/bloc/auth_state.dart';
import '../bloc/recommendation_bloc.dart';
import '../bloc/recommendation_event.dart';
import '../bloc/recommendation_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _userEmail = authState.user.email;
    }
  }

  void _onGenerate() {
    if (_userEmail.isEmpty) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        _userEmail = authState.user.email;
      }
    }
    context
        .read<RecommendationBloc>()
        .add(GenerateRecommendationSubmittedEvent(_userEmail));
  }

  void _onSignOut() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Keluar Akun",
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        content: Text(
          "Apakah Anda yakin ingin keluar dari akun?",
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffFF2020),
              minimumSize: const Size(80, 36),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AuthBloc>().add(SignOutRequestedEvent());
            },
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.signIn,
            (route) => false,
          );
        }
      },
      child: BlocConsumer<RecommendationBloc, RecommendationState>(
        listener: (context, state) {
          if (state is RecommendationLoaded) {
            Navigator.of(context).pushNamed(AppRoutes.generate);
          } else if (state is RecommendationFailure) {
            UiHelpers.showSnackBar(
              context,
              title: 'Gagal Menghasilkan Rekomendasi',
              message: state.errorMessage,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is RecommendationLoading;

          return Scaffold(
            body: Stack(
              children: [
                // Authentic Signature Animated Mesh Gradient
                Positioned.fill(
                  child: AnimatedMeshGradient(
                    colors: const [
                      Color(0xffFFE4D0),
                      Color(0xffFFFFFF),
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

                // Center Companion Content
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "Meet Your New",
                              style: GoogleFonts.inter(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff1E293B),
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              "AI Companion",
                              style: GoogleFonts.inter(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w800,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: <Color>[
                                      Color(0xffFD9A37),
                                      Color(0xffFF2020),
                                    ],
                                  ).createShader(
                                    const Rect.fromLTWH(0.0, 0.0, 240.0, 50.0),
                                  ),
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 28.w),

                            // Mascot with Soft Organic Shadow
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 170.w,
                                  height: 170.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xffFF2020).withValues(alpha: 0.15),
                                        blurRadius: 40,
                                        spreadRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  "assets/img/mascot.png",
                                  width: 190.w,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                            SizedBox(height: 22.w),

                            Text(
                              "Talk to Doctor Polichili",
                              style: GoogleFonts.inter(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff0F172A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 320),
                              child: Text(
                                "Need advice on suitable plants? Just click “Generate”,\nlet us help you choose the best one!",
                                style: GoogleFonts.inter(
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff475569),
                                  height: 1.45,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 36.w),

                            // Signature "Generate now" Action Button
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 310),
                              child: SizedBox(
                                width: double.infinity,
                                height: 48.h,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffFF2020),
                                    foregroundColor: Colors.white,
                                    elevation: 4,
                                    shadowColor: const Color(0xffFF2020).withValues(alpha: 0.4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: isLoading ? null : _onGenerate,
                                  child: Text(
                                    "Generate now",
                                    style: GoogleFonts.inter(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.w),

                            // Signature V1.0 Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xffFD9A37),
                                    Colors.deepOrange.shade700,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withValues(alpha: 0.25),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                "V1.0",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Authentic SpeedDial Menu (Polished with proper sizing)
                Positioned(
                  top: 12,
                  left: 16,
                  child: SafeArea(
                    child: SpeedDial(
                      icon: Icons.menu_rounded,
                      activeIcon: Icons.close_rounded,
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xffFF2020),
                      elevation: 4,
                      buttonSize: const Size(46, 46),
                      childrenButtonSize: const Size(44, 44),
                      direction: SpeedDialDirection.down,
                      switchLabelPosition: true,
                      spacing: 8,
                      spaceBetweenChildren: 8,
                      overlayOpacity: 0.2,
                      children: [
                        SpeedDialChild(
                          label: "Change Profile",
                          labelStyle: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff1E293B),
                          ),
                          labelBackgroundColor: Colors.white,
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xffFF2020),
                          child: const Icon(Icons.settings_suggest_outlined, size: 20),
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRoutes.changeProfile);
                          },
                        ),
                        SpeedDialChild(
                          label: "History Predict",
                          labelStyle: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff1E293B),
                          ),
                          labelBackgroundColor: Colors.white,
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xffFF2020),
                          child: const Icon(Icons.history_rounded, size: 20),
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRoutes.history);
                          },
                        ),
                        SpeedDialChild(
                          label: "Sign Out",
                          labelStyle: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffDC2626),
                          ),
                          labelBackgroundColor: Colors.white,
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xffDC2626),
                          child: const Icon(Icons.logout_rounded, size: 20),
                          onTap: _onSignOut,
                        ),
                      ],
                    ),
                  ),
                ),

                // Smooth Loading Feedback
                if (isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LoadingAnimationWidget.fourRotatingDots(
                              color: const Color(0xffFF2020),
                              size: 40,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "Generating recommendation...",
                              style: GoogleFonts.inter(
                                fontSize: 13,
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
          );
        },
      ),
    );
  }
}
