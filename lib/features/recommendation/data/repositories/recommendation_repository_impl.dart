import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
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
    try {
      final config = await localDataSource.getSensorConfig();
      if (config == null) {
        return const Left(CacheFailure('Konfigurasi sensor belum diatur di Profil'));
      }

      final deviceId = config['deviceId'];
      final sensorId = config['sensorId'];
      final userName = config['userName'];
      final token = await localDataSource.getAccessToken();

      if (deviceId == null || sensorId == null || userName == null || token == null) {
        return const Left(CacheFailure('Data sensor atau token belum lengkap'));
      }

      final sensorData = await remoteDataSource.fetchSensorData(
        userName: userName,
        deviceId: deviceId,
        sensorId: sensorId,
        accessToken: token,
      );

      return Right(sensorData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCropRecommendation(
    SensorDataEntity sensorData,
  ) async {
    try {
      final crops = await remoteDataSource.getCropRecommendation(
        suhu: sensorData.suhu,
        kelembabanUdara: sensorData.humidity,
        kelembabanTanah: sensorData.soilMoisture,
        ph: sensorData.ph,
      );
      return Right(crops);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TanamanEntity?>> getPlantDetails(String plantName) async {
    try {
      final plant = await remoteDataSource.getPlantDetails(plantName);
      return Right(plant);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> savePredictionLog({
    required String email,
    required SensorDataEntity sensorData,
    required String recommendation,
  }) async {
    try {
      await remoteDataSource.savePredictionLog(
        email: email,
        suhu: sensorData.suhu,
        kelembabanUdara: sensorData.humidity,
        kelembabanTanah: sensorData.soilMoisture,
        ph: sensorData.ph,
        recommendation: recommendation,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecommendationResultEntity>> generateFullRecommendation(
    String email,
  ) async {
    try {
      // 1. Ambil data sensor dari IoT
      final sensorResult = await fetchSensorData();
      if (sensorResult.isLeft()) {
        return Left((sensorResult as Left<Failure, SensorDataEntity>).value);
      }
      final sensorData = (sensorResult as Right<Failure, SensorDataEntity>).value;

      // 2. Kirim ke model AI untuk prediksi tanaman
      final cropResult = await getCropRecommendation(sensorData);
      if (cropResult.isLeft()) {
        return Left((cropResult as Left<Failure, List<String>>).value);
      }
      final crops = (cropResult as Right<Failure, List<String>>).value;

      if (crops.isEmpty) {
        return const Left(ServerFailure('Model AI tidak menghasilkan rekomendasi'));
      }

      final primaryCrop = crops[0];
      final alternativeCrops = crops.length > 1 ? crops.sublist(1) : <String>[];

      // 3. Ambil detail tanaman utama
      final plantResult = await getPlantDetails(primaryCrop);
      TanamanEntity? plantDetails;
      plantResult.fold((_) {}, (plant) => plantDetails = plant);

      // 4. Simpan log prediksi ke server MEEP Lab
      await savePredictionLog(
        email: email,
        sensorData: sensorData,
        recommendation: primaryCrop,
      );

      return Right(RecommendationResultEntity(
        sensorData: sensorData,
        plantDetails: plantDetails,
        primaryCropName: primaryCrop,
        alternativeCrops: alternativeCrops,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
