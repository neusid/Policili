import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    String email = '';
    if (authState is Authenticated) {
      email = authState.user.email;
    }
    context.read<HistoryBloc>().add(FetchHistoryEvent(email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFF2020),
      body: Stack(
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
              SizedBox(height: 0.15.sw),
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
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.03.sw),
              Container(
                width: 280.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: const Color(0xffE2E1E1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      topRight: Radius.circular(10.r),
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
                            color: Colors.red,
                            size: 50.w,
                          ),
                        );
                      }

                      if (state is HistoryLoaded) {
                        if (state.historyList.isEmpty) {
                          return const Center(
                            child: Text(
                              'Belum ada riwayat prediksi',
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        return Padding(
                          padding: EdgeInsets.only(
                            left: 0.05.sw,
                            right: 0.05.sw,
                          ),
                          child: ListView.builder(
                            itemCount: state.historyList.length,
                            itemBuilder: (context, index) {
                              final item = state.historyList[index];
                              return Column(
                                children: [
                                  CardHistory(
                                    imageUrl:
                                        "${ApiConstants.meepLabImageBaseUrl}/${item.recommendation}.png",
                                    plantName: item.recommendation,
                                    date: item.date,
                                    soilMoisture: item.kelembabanTanah,
                                    airMoisture: item.kelembabanUdara,
                                    ph: item.pH,
                                    temperature: item.suhu,
                                  ),
                                  SizedBox(height: 0.03.sw),
                                ],
                              );
                            },
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
