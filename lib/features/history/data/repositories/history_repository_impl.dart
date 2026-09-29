import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/mock/mock_data_service.dart';
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
    await Future.delayed(const Duration(milliseconds: 200));
    final history = List<HistoryPredictEntity>.from(
      MockDataService.instance.predictionHistory,
    );
    return Right(history);
  }
}
