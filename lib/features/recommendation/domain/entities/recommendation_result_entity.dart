import 'package:equatable/equatable.dart';
import 'sensor_data_entity.dart';
import 'tanaman_entity.dart';

class RecommendationResultEntity extends Equatable {
  final SensorDataEntity sensorData;
  final TanamanEntity? plantDetails;
  final String primaryCropName;
  final List<String> alternativeCrops;

  const RecommendationResultEntity({
    required this.sensorData,
    this.plantDetails,
    required this.primaryCropName,
    required this.alternativeCrops,
  });

  @override
  List<Object?> get props => [
        sensorData,
        plantDetails,
        primaryCropName,
        alternativeCrops,
      ];
}
