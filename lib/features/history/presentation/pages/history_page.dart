import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/policili_button.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          "Riwayat Prediksi",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        leading: widget.showBackButton && Navigator.canPop(context)
            ? IconButton(
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
              )
            : null,
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
            onPressed: _fetchHistory,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<HistoryBloc, HistoryState>(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Memuat riwayat analisis...",
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is HistoryLoaded) {
            final historyList = state.historyList;

            if (historyList.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppColors.emeraldSurface,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset("assets/img/mascot.png"),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "Belum Ada Riwayat",
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Lakukan generate rekomendasi di beranda untuk memulai pencatatan telemetri tanaman cabai Anda.",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
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
              color: AppColors.primary,
              onRefresh: () async => _fetchHistory(),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 110),
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
                ),
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
                  color: AppColors.textMuted,
                ),
                const SizedBox(height: 14),
                Text(
                  "Gagal memuat riwayat",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: 140,
                  child: PoliciliButton(
                    text: "Coba Lagi",
                    height: 42,
                    onPressed: _fetchHistory,
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
