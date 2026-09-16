import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class GetRememberMeUseCase {
  final AuthRepository repository;
  GetRememberMeUseCase(this.repository);

  Future<Either<Failure, bool>> call() {
    return repository.getRememberMe();
  }
}

class SetRememberMeUseCase {
  final AuthRepository repository;
  SetRememberMeUseCase(this.repository);

  Future<Either<Failure, void>> call(bool value) {
    return repository.setRememberMe(value);
  }
}

class GetSavedCredentialsUseCase {
  final AuthRepository repository;
  GetSavedCredentialsUseCase(this.repository);

  Future<Either<Failure, Map<String, String?>>> call() {
    return repository.getSavedCredentials();
  }
}
