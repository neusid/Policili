import 'package:equatable/equatable.dart';
import '../../domain/entities/external_user_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ExternalUserEntity user;
  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileUpdateSuccess extends ProfileState {
  final String message;
  final ExternalUserEntity user;
  const ProfileUpdateSuccess(this.message, this.user);

  @override
  List<Object?> get props => [message, user];
}

class ProfileFailure extends ProfileState {
  final String errorMessage;
  const ProfileFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
