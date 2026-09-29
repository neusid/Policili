import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/mock/mock_data_service.dart';
import '../../domain/entities/recommendation_result_entity.dart';
import '../../domain/entities/sensor_data_entity.dart';
import '../../domain/entities/tanaman_entity.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../datasources/recommendation_local_data_source.dart';
import '../datasources/recommendation_remote_data_source.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  final RecommendationRemoteDataSource remoteDataSource;
  final RecommendationLocalDataSource localDataSource;

  RecommendationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, SensorDataEntity>> fetchSensorData() async {
    await Future.delayed(const Duration(milliseconds: 250));
    final sensor = MockDataService.instance.getNextSensorData();
    return Right(sensor);
  }

  @override
  Future<Either<Failure, List<String>>> getCropRecommendation(
    SensorDataEntity sensorData,
  ) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const Right([
      'Cabai Rawit Merah',
      'Cabai Merah Keriting',
      'Tomat Ceri',
      'Paprika Hijau',
    ]);
  }

  @override
  Future<Either<Failure, TanamanEntity?>> getPlantDetails(String plantName) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final details = MockDataService.instance.getPlantDetailsFor(plantName);
    return Right(details);
  }

  @override
  Future<Either<Failure, void>> savePredictionLog({
    required String email,
    required SensorDataEntity sensorData,
    required String recommendation,
  }) async {
    MockDataService.instance.addPredictionRecord(
      email: email,
      sensor: sensorData,
      recommendation: recommendation,
    );
    return const Right(null);
  }

  @override
  Future<Either<Failure, RecommendationResultEntity>> generateFullRecommendation(
    String email,
  ) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final sensorData = MockDataService.instance.getNextSensorData();

    const crops = [
      'Cabai Rawit Merah',
      'Cabai Merah Keriting',
      'Tomat Ceri',
    ];
    final primaryCrop = crops.first;
    final plantDetails = MockDataService.instance.getPlantDetailsFor(primaryCrop);
    final alternatives = crops.skip(1).toList();

    // Simpan ke in-memory history log
    MockDataService.instance.addPredictionRecord(
      email: email,
      sensor: sensorData,
      recommendation: primaryCrop,
    );

    return Right(RecommendationResultEntity(
      primaryCropName: primaryCrop,
      plantDetails: plantDetails,
      sensorData: sensorData,
      alternativeCrops: alternatives,
    ));
  }
}
