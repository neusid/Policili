import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  static UserEntity _currentUser = const UserEntity(
    uid: 'offline_policili_user_01',
    email: 'user@policili.com',
    displayName: 'Pengguna Policili',
  );

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final finalEmail = email.trim().isNotEmpty ? email.trim() : 'user@policili.com';
    final user = UserEntity(
      uid: 'offline_policili_user_01',
      email: finalEmail,
      displayName: 'Pengguna Policili',
    );
    _currentUser = user;
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
    final user = UserEntity(
      uid: 'offline_policili_user_01',
      email: email.trim().isNotEmpty ? email.trim() : 'user@policili.com',
      displayName: name.trim().isNotEmpty ? name.trim() : 'Pengguna Policili',
    );
    _currentUser = user;
    await localDataSource.saveCredentials(email: user.email, password: password);
    return Right(user);
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    await localDataSource.clearCredentials();
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    final credentials = await localDataSource.getCredentials();
    final savedEmail = credentials['email'];
    if (savedEmail != null && savedEmail.isNotEmpty) {
      _currentUser = UserEntity(
        uid: 'offline_policili_user_01',
        email: savedEmail,
        displayName: 'Pengguna Policili',
      );
    }
    return Right(_currentUser);
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

