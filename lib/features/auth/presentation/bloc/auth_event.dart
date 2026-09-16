import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class SignInSubmittedEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInSubmittedEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignUpSubmittedEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String deviceId;
  final String sensorId;
  final String usernameThinger;

  const SignUpSubmittedEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.deviceId,
    required this.sensorId,
    required this.usernameThinger,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        name,
        deviceId,
        sensorId,
        usernameThinger,
      ];
}

class SignOutRequestedEvent extends AuthEvent {}

class ToggleRememberMeEvent extends AuthEvent {
  final bool value;
  const ToggleRememberMeEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class LoadSavedCredentialsEvent extends AuthEvent {}
