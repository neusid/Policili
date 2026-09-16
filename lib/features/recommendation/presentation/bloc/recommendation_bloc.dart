import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/recommendation_usecases.dart';
import 'recommendation_event.dart';
import 'recommendation_state.dart';

class RecommendationBloc
    extends Bloc<RecommendationEvent, RecommendationState> {
  final GenerateFullRecommendationUseCase generateFullRecommendationUseCase;

  RecommendationBloc({
    required this.generateFullRecommendationUseCase,
  }) : super(RecommendationInitial()) {
    on<GenerateRecommendationSubmittedEvent>(_onGenerateRecommendation);
    on<RefreshRecommendationEvent>(_onRefreshRecommendation);
    on<ResetRecommendationEvent>(_onResetRecommendation);
  }

  Future<void> _onGenerateRecommendation(
    GenerateRecommendationSubmittedEvent event,
    Emitter<RecommendationState> emit,
  ) async {
    emit(RecommendationLoading());
    final result = await generateFullRecommendationUseCase(event.email);

    result.fold(
      (failure) => emit(RecommendationFailure(failure.message)),
      (data) => emit(RecommendationLoaded(data)),
    );
  }

  Future<void> _onRefreshRecommendation(
    RefreshRecommendationEvent event,
    Emitter<RecommendationState> emit,
  ) async {
    emit(RecommendationLoading());
    final result = await generateFullRecommendationUseCase(event.email);

    result.fold(
      (failure) => emit(RecommendationFailure(failure.message)),
      (data) => emit(RecommendationLoaded(data)),
    );
  }

  void _onResetRecommendation(
    ResetRecommendationEvent event,
    Emitter<RecommendationState> emit,
  ) {
    emit(RecommendationInitial());
  }
}
