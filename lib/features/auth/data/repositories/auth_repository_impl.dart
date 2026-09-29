import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/mock/mock_data_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final finalEmail = email.trim().isNotEmpty ? email.trim() : 'user@policili.com';
    MockDataService.instance.userEmail = finalEmail;

    final user = UserEntity(
      uid: 'offline_policili_user_01',
      email: finalEmail,
      displayName: MockDataService.instance.userName,
    );
    await localDataSource.saveCredentials(email: finalEmail, password: password);
    return Right(user);
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
    required String deviceId,
    required String sensorId,
    required String usernameThinger,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final finalEmail = email.trim().isNotEmpty ? email.trim() : 'user@policili.com';
    final finalName = name.trim().isNotEmpty ? name.trim() : 'Pengguna Policili';

    MockDataService.instance.userEmail = finalEmail;
    MockDataService.instance.userName = finalName;
    MockDataService.instance.deviceId = deviceId;
    MockDataService.instance.sensorId = sensorId;
    MockDataService.instance.usernameThinger = usernameThinger;

    final user = UserEntity(
      uid: 'offline_policili_user_01',
      email: finalEmail,
      displayName: finalName,
    );
    await localDataSource.saveCredentials(email: finalEmail, password: password);
    return Right(user);
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    await Future.delayed(const Duration(milliseconds: 150));
    await localDataSource.clearCredentials();
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    final credentials = await localDataSource.getCredentials();
    final savedEmail = credentials['email'];
    if (savedEmail != null && savedEmail.isNotEmpty) {
      MockDataService.instance.userEmail = savedEmail;
    }
    return Right(UserEntity(
      uid: 'offline_policili_user_01',
      email: MockDataService.instance.userEmail,
      displayName: MockDataService.instance.userName,
    ));
  }

  @override
  Future<Either<Failure, bool>> getRememberMe() async {
    try {
      final result = await localDataSource.getRememberMe();
      return Right(result);
    } catch (_) {
      return const Right(true);
    }
  }

  @override
  Future<Either<Failure, void>> setRememberMe(bool value) async {
    try {
      await localDataSource.setRememberMe(value);
      return const Right(null);
    } catch (_) {
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, Map<String, String?>>> getSavedCredentials() async {
    try {
      final result = await localDataSource.getCredentials();
      return Right(result);
    } catch (_) {
      return const Right({'email': 'user@policili.com', 'password': 'password'});
    }
  }
}
