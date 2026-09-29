import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/mock/mock_data_service.dart';
import '../../domain/entities/external_user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ExternalUserEntity>> getUserProfile(String email) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final mock = MockDataService.instance;
    return Right(ExternalUserEntity(
      id: 1,
      name: mock.userName,
      email: mock.userEmail,
      deviceId: mock.deviceId,
      sensorId: mock.sensorId,
      usernameThinger: mock.usernameThinger,
    ));
  }

  @override
  Future<Either<Failure, String>> updateUserProfile(ExternalUserEntity user) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final mock = MockDataService.instance;
    mock.userName = user.name;
    mock.deviceId = user.deviceId;
    mock.sensorId = user.sensorId;
    mock.usernameThinger = user.usernameThinger;
    return const Right("Profil dan konfigurasi IoT berhasil disimpan");
  }

  @override
  Future<Either<Failure, void>> saveLocalSensorData(ExternalUserEntity user) async {
    final mock = MockDataService.instance;
    mock.userName = user.name;
    mock.deviceId = user.deviceId;
    mock.sensorId = user.sensorId;
    mock.usernameThinger = user.usernameThinger;
    return const Right(null);
  }

  @override
  Future<Either<Failure, ExternalUserEntity?>> getLocalSensorData() async {
    final mock = MockDataService.instance;
    return Right(ExternalUserEntity(
      id: 1,
      name: mock.userName,
      email: mock.userEmail,
      deviceId: mock.deviceId,
      sensorId: mock.sensorId,
      usernameThinger: mock.usernameThinger,
    ));
  }

  @override
  Future<Either<Failure, void>> syncThingerToken() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> refreshThingerToken() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return const Right(null);
  }
}
