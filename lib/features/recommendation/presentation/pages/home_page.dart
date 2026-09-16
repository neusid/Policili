import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import '../../../../app/config/routes/app_routes.dart';
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
            body: AnimatedMeshGradient(
              colors: const [
                Color(0xffFFE4D0),
                Color(0xffFFFFFF),
                Color(0xffFFE4ff),
                Color(0xffFCD8DA),
              ],
              options: AnimatedMeshGradientOptions(
                speed: 0.05,
                frequency: 7,
                amplitude: 30,
                grain: 0.1,
              ),
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 50.w),
                        Text(
                          "Meet Your New",
                          style: GoogleFonts.inter(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "AI Companion",
                          style: GoogleFonts.inter(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: <Color>[
                                  Colors.orangeAccent,
                                  Color(0xffFF2020),
                                ],
                              ).createShader(
                                const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                              ),
                          ),
                        ),
                        SizedBox(height: 30.w),
                        Image.asset("assets/img/mascot.png"),
                        SizedBox(height: 25.w),
                        Text(
                          "Talk to Doctor Polichili",
                          style: GoogleFonts.inter(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5.w),
                        SizedBox(
                          width: 310.w,
                          child: Text(
                            "Need advice on suitable plants? Just click “Generate”,\nlet us help you choose the best one!",
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 50.w),
                        SizedBox(
                          width: 300.w,
                          height: 40.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffFF2020),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                            ),
                            onPressed: isLoading ? null : _onGenerate,
                            child: Text(
                              "Generate now",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 0.12.sw),
                        Container(
                          width: 0.22.sw,
                          height: 0.08.sw,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0.08.sw),
                            gradient: LinearGradient(
                              colors: [Colors.orange, Colors.deepOrange.shade700],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "V1.0",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.red,
                          size: 50.w,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            floatingActionButton: SpeedDial(
              icon: Icons.menu,
              foregroundColor: Colors.white,
              buttonSize: Size(0.12.sw, 0.12.sw),
              backgroundColor: const Color(0xffFF2020),
              direction: SpeedDialDirection.down,
              switchLabelPosition: true,
              children: [
                SpeedDialChild(
                  label: "Change Profile",
                  labelBackgroundColor: Colors.white10,
                  child: const Icon(Icons.settings_suggest_outlined),
                  shape: const CircleBorder(),
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.changeProfile);
                  },
                ),
                SpeedDialChild(
                  label: "History Predict",
                  labelBackgroundColor: Colors.white10,
                  child: const Icon(Icons.history),
                  shape: const CircleBorder(),
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.history);
                  },
                ),
                SpeedDialChild(
                  label: "Sign Out",
                  labelBackgroundColor: Colors.white10,
                  child: const Icon(Icons.logout),
                  shape: const CircleBorder(),
                  onTap: () {
                    context.read<AuthBloc>().add(SignOutRequestedEvent());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
