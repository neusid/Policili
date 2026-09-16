import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recommendation_result_entity.dart';
import '../entities/sensor_data_entity.dart';
import '../entities/tanaman_entity.dart';
import '../repositories/recommendation_repository.dart';

class FetchSensorDataUseCase {
  final RecommendationRepository repository;
  FetchSensorDataUseCase(this.repository);

  Future<Either<Failure, SensorDataEntity>> call() {
    return repository.fetchSensorData();
  }
}

class GetCropRecommendationUseCase {
  final RecommendationRepository repository;
  GetCropRecommendationUseCase(this.repository);

  Future<Either<Failure, List<String>>> call(SensorDataEntity sensorData) {
    return repository.getCropRecommendation(sensorData);
  }
}

class GetPlantDetailsUseCase {
  final RecommendationRepository repository;
  GetPlantDetailsUseCase(this.repository);

  Future<Either<Failure, TanamanEntity?>> call(String plantName) {
    return repository.getPlantDetails(plantName);
  }
}

class SavePredictionLogUseCase {
  final RecommendationRepository repository;
  SavePredictionLogUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required SensorDataEntity sensorData,
    required String recommendation,
  }) {
    return repository.savePredictionLog(
      email: email,
      sensorData: sensorData,
      recommendation: recommendation,
    );
  }
}

class GenerateFullRecommendationUseCase {
  final RecommendationRepository repository;
  GenerateFullRecommendationUseCase(this.repository);

  Future<Either<Failure, RecommendationResultEntity>> call(String email) {
    return repository.generateFullRecommendation(email);
  }
}
