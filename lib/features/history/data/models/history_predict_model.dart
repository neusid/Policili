import '../../domain/entities/history_predict_entity.dart';

class HistoryPredictModel extends HistoryPredictEntity {
  const HistoryPredictModel({
    required super.id,
    required super.email,
    required super.pH,
    required super.kelembabanUdara,
    required super.kelembabanTanah,
    required super.suhu,
    required super.recommendation,
    required super.date,
  });

  factory HistoryPredictModel.fromJson(Map<String, dynamic> json) =>
      HistoryPredictModel(
        id: json["id"] ?? 0,
        email: json["email"] ?? '',
        pH: json["pH"]?.toString() ?? '',
        kelembabanUdara: json["kelembabanUdara"]?.toString() ?? '',
        kelembabanTanah: json["kelembabanTanah"]?.toString() ?? '',
        suhu: json["suhu"]?.toString() ?? '',
        recommendation: json["recommendation"] ?? '',
        date: json["date"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "pH": pH,
        "kelembabanUdara": kelembabanUdara,
        "kelembabanTanah": kelembabanTanah,
        "suhu": suhu,
        "recommendation": recommendation,
        "date": date,
      };
}
