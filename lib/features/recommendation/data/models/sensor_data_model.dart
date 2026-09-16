import '../../domain/entities/sensor_data_entity.dart';

class SensorDataModel extends SensorDataEntity {
  const SensorDataModel({
    required super.suhu,
    required super.humidity,
    required super.soilMoisture,
    required super.ph,
  });

  factory SensorDataModel.fromThingerRaw(String rawData) {
    // Format dari Thinger: "humidity#suhu#soilMoisture#ph"
    final parts = rawData.split('#');
    final tempHumidity = double.tryParse(parts[0]) != null
        ? (double.parse(parts[0]) / 100).toStringAsFixed(2)
        : parts[0];
    final tempSoil = double.tryParse(parts[2]) != null
        ? (double.parse(parts[2]) / 100).toStringAsFixed(2)
        : parts[2];

    return SensorDataModel(
      humidity: tempHumidity,
      suhu: parts.length > 1 ? parts[1] : '',
      soilMoisture: tempSoil,
      ph: parts.length > 3 ? parts[3] : '',
    );
  }

  factory SensorDataModel.fromJson(Map<String, dynamic> json) => SensorDataModel(
        suhu: json['suhu']?.toString() ?? '',
        humidity: json['humidity']?.toString() ?? json['kelembabanUdara']?.toString() ?? '',
        soilMoisture: json['soilMoisture']?.toString() ?? json['kelembabanTanah']?.toString() ?? '',
        ph: json['ph']?.toString() ?? json['pH']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'suhu': suhu,
        'humidity': humidity,
        'soilMoisture': soilMoisture,
        'ph': ph,
      };
}
