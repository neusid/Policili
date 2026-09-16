import 'package:equatable/equatable.dart';

class SensorDataEntity extends Equatable {
  final String suhu;
  final String humidity;
  final String soilMoisture;
  final String ph;

  const SensorDataEntity({
    required this.suhu,
    required this.humidity,
    required this.soilMoisture,
    required this.ph,
  });

  @override
  List<Object?> get props => [suhu, humidity, soilMoisture, ph];
}
