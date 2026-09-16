import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recommendation_result_entity.dart';
import '../entities/sensor_data_entity.dart';
import '../entities/tanaman_entity.dart';

abstract class RecommendationRepository {
  Future<Either<Failure, SensorDataEntity>> fetchSensorData();

  Future<Either<Failure, List<String>>> getCropRecommendation(SensorDataEntity sensorData);

  Future<Either<Failure, TanamanEntity?>> getPlantDetails(String plantName);

  Future<Either<Failure, void>> savePredictionLog({
    required String email,
    required SensorDataEntity sensorData,
    required String recommendation,
  });

  Future<Either<Failure, RecommendationResultEntity>> generateFullRecommendation(String email);
}
