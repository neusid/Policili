import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/external_user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/external_user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ExternalUserEntity>> getUserProfile(String email) async {
    try {
      final model = await remoteDataSource.getUserProfile(email);
      await localDataSource.saveSensorData(model);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateUserProfile(ExternalUserEntity user) async {
    try {
      final model = ExternalUserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        deviceId: user.deviceId,
        sensorId: user.sensorId,
        usernameThinger: user.usernameThinger,
      );
      final response = await remoteDataSource.updateUserProfile(model);
      await localDataSource.saveSensorData(model);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveLocalSensorData(ExternalUserEntity user) async {
    try {
      final model = ExternalUserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        deviceId: user.deviceId,
        sensorId: user.sensorId,
        usernameThinger: user.usernameThinger,
      );
      await localDataSource.saveSensorData(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ExternalUserEntity?>> getLocalSensorData() async {
    try {
      final data = await localDataSource.getSensorData();
      return Right(data);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> syncThingerToken() async {
    try {
      final sensorData = await localDataSource.getSensorData();
      final password = await localDataSource.getSavedPassword();

      if (sensorData != null && password != null && sensorData.usernameThinger.isNotEmpty) {
        final tokenData = await remoteDataSource.getThingerToken(
          username: sensorData.usernameThinger,
          password: password,
        );
        await localDataSource.saveTokens(
          accessToken: tokenData['access_token'],
          refreshToken: tokenData['refresh_token'],
        );
      }
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> refreshThingerToken() async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken != null) {
        final tokenData = await remoteDataSource.refreshThingerToken(refreshToken);
        await localDataSource.saveTokens(
          accessToken: tokenData['access_token'],
          refreshToken: tokenData['refresh_token'],
        );
      }
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
