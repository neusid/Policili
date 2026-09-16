import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/external_user_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;
  GetProfileUseCase(this.repository);

  Future<Either<Failure, ExternalUserEntity>> call(String email) {
    return repository.getUserProfile(email);
  }
}

class UpdateProfileUseCase {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, String>> call(ExternalUserEntity user) {
    return repository.updateUserProfile(user);
  }
}

class GetLocalSensorDataUseCase {
  final ProfileRepository repository;
  GetLocalSensorDataUseCase(this.repository);

  Future<Either<Failure, ExternalUserEntity?>> call() {
    return repository.getLocalSensorData();
  }
}

class SaveLocalSensorDataUseCase {
  final ProfileRepository repository;
  SaveLocalSensorDataUseCase(this.repository);

  Future<Either<Failure, void>> call(ExternalUserEntity user) {
    return repository.saveLocalSensorData(user);
  }
}

class SyncThingerTokenUseCase {
  final ProfileRepository repository;
  SyncThingerTokenUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.syncThingerToken();
  }
}
