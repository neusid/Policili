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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum ada data rekomendasi'),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Kembali ke Beranda'),
                  ),
                ],
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
              Positioned.fill(
                child: AnimatedMeshGradient(
                  colors: const [
                    Color(0xffFFE4D0),
                    Color(0xffFDE6E7),
                    Color(0xffFFE4ff),
                    Color(0xffFCD8DA),
                  ],
                  options: AnimatedMeshGradientOptions(
                    speed: 0.05,
                    frequency: 7,
                    amplitude: 30,
                    grain: 0.1,
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
              if (result != null)
                SingleChildScrollView(
                  child: SizedBox(
                    height: 1.sh,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15.w),
                                  bottomLeft: Radius.circular(15.w),
                                ),
                                image: const DecorationImage(
                                  image: AssetImage("assets/img/bg_card.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: 0.95.sw,
                            ),
                            Column(
                              children: [
                                SizedBox(height: 0.1.sw),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          width: 0.13.sw,
                                          height: 0.13.sw,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffD9D9D9),
                                            borderRadius:
                                                BorderRadius.circular(10.w),
                                          ),
                                          child: const Icon(Icons.arrow_back),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 0.2.sw),
                                  Stack(
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(height: 0.17.sh),
                                          Container(
                                            width: 200.w,
                                            height: 20.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.w),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                  blurRadius: 50,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (plant != null && plant.url.isNotEmpty)
                                        Image.network(
                                          "${ApiConstants.meepLabImageBaseUrl}/${plant.url}",
                                          width: 200.w,
                                          errorBuilder: (_, __, ___) =>
                                              Image.asset(
                                            "assets/img/mascot.png",
                                            width: 200.w,
                                          ),
                                        )
                                      else
                                        Image.asset(
                                          "assets/img/mascot.png",
                                          width: 200.w,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(height: 0.75.sw),
                                Text(
                                  plant?.name ?? result.primaryCropName,
                                  style: GoogleFonts.roboto(
                                    fontSize: 18.sp,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 0.05.sw),
                                Center(
                                  child: Container(
                                    width: 0.9.sw,
                                    constraints: BoxConstraints(
                                      minHeight: 0.2.sw,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.w),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 10.w,
                                        bottom: 10.w,
                                        left: 25.w,
                                        right: 25.w,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/img/search.png",
                                            width: 35.w,
                                          ),
                                          SizedBox(width: 15.w),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Manfaat",
                                                  style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13.5.sp,
                                                  ),
                                                ),
                                                Text(
                                                  plant?.kelebihan ??
                                                      "Tanaman cocok dibudidayakan pada parameter tanah saat ini.",
                                                  style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 11.h),
                        SizedBox(
                          width: 0.9.sw,
                          height: 0.9.sw,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  top: 10.w,
                                  bottom: 10.w,
                                  left: 25.w,
                                  right: 25.w,
                                ),
                                width: 0.9.sw,
                                constraints: BoxConstraints(
                                  minHeight: 0.21.sw,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.w),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/img/list.png",
                                      width: 35.w,
                                    ),
                                    SizedBox(width: 15.w),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Alternatif",
                                            style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13.5.sp,
                                            ),
                                          ),
                                          for (final alt in alternatives.take(2))
                                            Text(
                                              alt,
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13.sp,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 11.h),
                              CardDevice(
                                logo: "Mm",
                                labelName: "Temprature",
                                labelValue: sensor?.suhu ?? "30",
                                status: "Success",
                              ),
                              SizedBox(height: 11.h),
                              CardDevice(
                                logo: "Mm",
                                labelName: "Air Humidity",
                                labelValue: sensor?.humidity ?? "0.61",
                                status: "Success",
                              ),
                              SizedBox(height: 11.h),
                              CardDevice(
                                logo: "Mm",
                                labelName: "Soil Humidity",
                                labelValue: sensor?.soilMoisture ?? "-",
                                status: "Success",
                              ),
                              SizedBox(height: 11.h),
                              CardDevice(
                                logo: "Mm",
                                labelName: "PH",
                                labelValue: sensor?.ph ?? "-",
                                status: "Success",
                              ),
                              SizedBox(height: 11.h),
                            ],
                          ),
                        ),
                      ],
                    ),
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
          bottomNavigationBar: CurvedNavigationBar(
            index: 1,
            backgroundColor: Colors.transparent,
            buttonBackgroundColor: const Color(0xffFD9A37),
            height: 60.w,
            items: [
              Icon(Icons.home, size: 25.w, color: const Color(0xff6A0606)),
              Icon(Icons.refresh, size: 25.w, color: Colors.white),
              Icon(Icons.settings_suggest_outlined,
                  color: Colors.grey, size: 25.w),
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
