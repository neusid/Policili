import 'package:equatable/equatable.dart';
import '../../domain/entities/recommendation_result_entity.dart';

abstract class RecommendationState extends Equatable {
  const RecommendationState();

  @override
  List<Object?> get props => [];
}

class RecommendationInitial extends RecommendationState {}

class RecommendationLoading extends RecommendationState {}

class RecommendationLoaded extends RecommendationState {
  final RecommendationResultEntity result;
  const RecommendationLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class RecommendationFailure extends RecommendationState {
  final String errorMessage;
  const RecommendationFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
