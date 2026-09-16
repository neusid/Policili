import 'package:equatable/equatable.dart';

abstract class RecommendationEvent extends Equatable {
  const RecommendationEvent();

  @override
  List<Object?> get props => [];
}

class GenerateRecommendationSubmittedEvent extends RecommendationEvent {
  final String email;
  const GenerateRecommendationSubmittedEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class RefreshRecommendationEvent extends RecommendationEvent {
  final String email;
  const RefreshRecommendationEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class ResetRecommendationEvent extends RecommendationEvent {}
