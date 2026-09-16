import 'package:equatable/equatable.dart';
import '../../domain/entities/history_predict_entity.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryPredictEntity> historyList;
  const HistoryLoaded(this.historyList);

  @override
  List<Object?> get props => [historyList];
}

class HistoryFailure extends HistoryState {
  final String errorMessage;
  const HistoryFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
