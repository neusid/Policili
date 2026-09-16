import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchHistoryEvent extends HistoryEvent {
  final String email;
  const FetchHistoryEvent(this.email);

  @override
  List<Object?> get props => [email];
}
