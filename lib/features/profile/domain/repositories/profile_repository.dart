import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/external_user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ExternalUserEntity>> getUserProfile(String email);

  Future<Either<Failure, String>> updateUserProfile(ExternalUserEntity user);

  Future<Either<Failure, void>> saveLocalSensorData(ExternalUserEntity user);

  Future<Either<Failure, ExternalUserEntity?>> getLocalSensorData();

  Future<Either<Failure, void>> syncThingerToken();

  Future<Either<Failure, void>> refreshThingerToken();
}
