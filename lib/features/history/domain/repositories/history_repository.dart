import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/history_predict_entity.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<HistoryPredictEntity>>> getPredictionHistory(String email);
}
