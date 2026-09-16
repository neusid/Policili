import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_prediction_history_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetPredictionHistoryUseCase getPredictionHistoryUseCase;

  HistoryBloc({required this.getPredictionHistoryUseCase})
      : super(HistoryInitial()) {
    on<FetchHistoryEvent>(_onFetchHistory);
  }

  Future<void> _onFetchHistory(
    FetchHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    final result = await getPredictionHistoryUseCase(event.email);

    result.fold(
      (failure) => emit(HistoryFailure(failure.message)),
      (data) => emit(HistoryLoaded(data)),
    );
  }
}
