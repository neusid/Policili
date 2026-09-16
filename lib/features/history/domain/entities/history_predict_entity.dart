import 'package:equatable/equatable.dart';

class HistoryPredictEntity extends Equatable {
  final int id;
  final String email;
  final String pH;
  final String kelembabanUdara;
  final String kelembabanTanah;
  final String suhu;
  final String recommendation;
  final String date;

  const HistoryPredictEntity({
    required this.id,
    required this.email,
    required this.pH,
    required this.kelembabanUdara,
    required this.kelembabanTanah,
    required this.suhu,
    required this.recommendation,
    required this.date,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        pH,
        kelembabanUdara,
        kelembabanTanah,
        suhu,
        recommendation,
        date,
      ];
}
