import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/external_user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/external_user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  static ExternalUserModel _cachedUser = const ExternalUserModel(
    id: 1,
    name: "Petani Cerdas Malik",
    email: "user@policili.com",
    deviceId: "POLICILI-IOT-01",
    sensorId: "SOIL-CLIMATE-01",
    usernameThinger: "policili_user",
  );

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ExternalUserEntity>> getUserProfile(String email) async {
    final local = await localDataSource.getSensorData();
    if (local != null) {
      _cachedUser = local;
      return Right(local);
    }
    await localDataSource.saveSensorData(_cachedUser);
    return Right(_cachedUser);
  }

  @override
  Future<Either<Failure, String>> updateUserProfile(ExternalUserEntity user) async {
    _cachedUser = ExternalUserModel(
      id: user.id ?? 1,
      name: user.name,
      email: user.email,
      deviceId: user.deviceId,
      sensorId: user.sensorId,
      usernameThinger: user.usernameThinger,
    );
    await localDataSource.saveSensorData(_cachedUser);
    return const Right("Profil berhasil disimpan (Mode Offline)");
  }

  @override
  Future<Either<Failure, void>> saveLocalSensorData(ExternalUserEntity user) async {
    _cachedUser = ExternalUserModel(
      id: user.id ?? 1,
      name: user.name,
      email: user.email,
      deviceId: user.deviceId,
      sensorId: user.sensorId,
      usernameThinger: user.usernameThinger,
    );
    await localDataSource.saveSensorData(_cachedUser);
    return const Right(null);
  }

  @override
  Future<Either<Failure, ExternalUserEntity?>> getLocalSensorData() async {
    final local = await localDataSource.getSensorData();
    if (local != null) {
      _cachedUser = local;
    }
    return Right(_cachedUser);
  }

  @override
  Future<Either<Failure, void>> syncThingerToken() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> refreshThingerToken() async {
    return const Right(null);
  }
}
