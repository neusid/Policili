import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final String? message;
  const AuthLoading({this.message});

  @override
  List<Object?> get props => [message];
}

class Authenticated extends AuthState {
  final UserEntity user;
  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  final bool rememberMe;
  final String? savedEmail;
  final String? savedPassword;

  const Unauthenticated({
    this.rememberMe = false,
    this.savedEmail,
    this.savedPassword,
  });

  @override
  List<Object?> get props => [rememberMe, savedEmail, savedPassword];
}

class AuthFailureState extends AuthState {
  final String errorMessage;
  const AuthFailureState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class SignUpSuccessState extends AuthState {
  final String message;
  const SignUpSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}
