import 'package:equatable/equatable.dart';
import '../../domain/entities/external_user_entity.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  final String? email;
  const LoadProfileEvent([this.email]);

  @override
  List<Object?> get props => [email];
}

class UpdateProfileEvent extends ProfileEvent {
  final ExternalUserEntity user;
  const UpdateProfileEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class SyncThingerTokenEvent extends ProfileEvent {}
