import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String name,
    required String deviceId,
    required String sensorId,
    required String usernameThinger,
  }) {
    return repository.signUp(
      email: email,
      password: password,
      name: name,
      deviceId: deviceId,
      sensorId: sensorId,
      usernameThinger: usernameThinger,
    );
  }
}
