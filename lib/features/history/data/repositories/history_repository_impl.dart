import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/history_predict_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<HistoryPredictEntity>>> getPredictionHistory(
    String email,
  ) async {
    try {
      final historyList = await remoteDataSource.getPredictionHistory(email);
      return Right(historyList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
