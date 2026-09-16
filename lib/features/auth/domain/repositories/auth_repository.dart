import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
    required String deviceId,
    required String sensorId,
    required String usernameThinger,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, bool>> getRememberMe();

  Future<Either<Failure, void>> setRememberMe(bool value);

  Future<Either<Failure, Map<String, String?>>> getSavedCredentials();
}
