import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/ui_helpers.dart';
import 'package:policili_apps/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:policili_apps/features/auth/presentation/bloc/auth_state.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import '../widgets/card_history.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
    this.showBackButton = true,
  });

  final bool showBackButton;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  void _fetchHistory() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _userEmail = authState.user.email;
    }
    context.read<HistoryBloc>().add(FetchHistoryEvent(_userEmail));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFF2020),
      body: Stack(
        children: [
          // Authentic Top Red Banner with bg_card.png
          Container(
            width: double.infinity,
            height: 0.95.sw,
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
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Navigation Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  child: Row(
                    children: [
                      if (widget.showBackButton && Navigator.canPop(context))
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              color: const Color(0xffD9D9D9),
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Color(0xff1E293B),
                            ),
                          ),
                        ),
                      SizedBox(width: 14.w),
                      Text(
                        "Riwayat Prediksi",
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: "Muat Ulang",
                        icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                        onPressed: _fetchHistory,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // Signature Arched Tab Accent
                Container(
                  width: 280.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36.r),
                      topRight: Radius.circular(36.r),
                    ),
                  ),
                ),

                // Signature Gray Card Sheet Container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xffE2E1E1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                    ),
                    child: BlocConsumer<HistoryBloc, HistoryState>(
                      listener: (context, state) {
                        if (state is HistoryFailure) {
                          UiHelpers.showSnackBar(
                            context,
                            title: 'Gagal Memuat Riwayat',
                            message: state.errorMessage,
                            isError: true,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is HistoryLoading) {
                          return Center(
                            child: LoadingAnimationWidget.fourRotatingDots(
                              color: const Color(0xffFF2020),
                              size: 48.w,
                            ),
                          );
                        }

                        if (state is HistoryLoaded) {
                          final historyList = state.historyList;

                          if (historyList.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 32.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/img/mascot.png",
                                      width: 100.w,
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      "Belum Ada Riwayat",
                                      style: GoogleFonts.inter(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xff1E293B),
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      "Lakukan generate rekomendasi di beranda untuk memulai pencatatan telemetri tanaman cabai Anda.",
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5.sp,
                                        color: const Color(0xff64748B),
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return RefreshIndicator(
                            color: const Color(0xffFF2020),
                            onRefresh: () async => _fetchHistory(),
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              itemCount: historyList.length,
                              itemBuilder: (context, index) {
                                final history = historyList[index];
                                final imageUrl = history.recommendation.isNotEmpty
                                    ? "${ApiConstants.meepLabImageBaseUrl}/${history.recommendation.toLowerCase().replaceAll(' ', '_')}.png"
                                    : '';

                                return CardHistory(
                                  imageUrl: imageUrl,
                                  plantName: history.recommendation.isNotEmpty
                                      ? history.recommendation
                                      : 'Cabai Rekomendasi',
                                  date: history.date,
                                  soilMoisture: history.kelembabanTanah,
                                  airMoisture: history.kelembabanUdara,
                                  ph: history.pH,
                                  temperature: history.suhu,
                                );
                              },
                            ),
                          );
                        }

                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.signal_wifi_bad_rounded,
                                size: 44,
                                color: Color(0xff94A3B8),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                "Gagal memuat riwayat",
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff1E293B),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              ElevatedButton(
                                onPressed: _fetchHistory,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffFF2020),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: const Text("Coba Lagi"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
