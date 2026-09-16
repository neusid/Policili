import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/history_predict_entity.dart';
import '../repositories/history_repository.dart';

class GetPredictionHistoryUseCase {
  final HistoryRepository repository;
  GetPredictionHistoryUseCase(this.repository);

  Future<Either<Failure, List<HistoryPredictEntity>>> call(String email) {
    return repository.getPredictionHistory(email);
  }
}
