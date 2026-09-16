import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/remember_me_usecases.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetRememberMeUseCase getRememberMeUseCase;
  final SetRememberMeUseCase setRememberMeUseCase;
  final GetSavedCredentialsUseCase getSavedCredentialsUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.getRememberMeUseCase,
    required this.setRememberMeUseCase,
    required this.getSavedCredentialsUseCase,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignInSubmittedEvent>(_onSignInSubmitted);
    on<SignUpSubmittedEvent>(_onSignUpSubmitted);
    on<SignOutRequestedEvent>(_onSignOutRequested);
    on<ToggleRememberMeEvent>(_onToggleRememberMe);
    on<LoadSavedCredentialsEvent>(_onLoadSavedCredentials);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final userResult = await getCurrentUserUseCase();
    final rememberResult = await getRememberMeUseCase();

    final isRemembered = rememberResult.getOrElse(() => false);

    await userResult.fold(
      (failure) async {
        emit(Unauthenticated(rememberMe: isRemembered));
      },
      (user) async {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          Map<String, String?> credentials = {};
          if (isRemembered) {
            final credResult = await getSavedCredentialsUseCase();
            credentials = credResult.getOrElse(() => {});
          }
          emit(Unauthenticated(
            rememberMe: isRemembered,
            savedEmail: credentials['email'],
            savedPassword: credentials['password'],
          ));
        }
      },
    );
  }

  Future<void> _onSignInSubmitted(
    SignInSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await signInUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await signUpUseCase(
      email: event.email,
      password: event.password,
      name: event.name,
      deviceId: event.deviceId,
      sensorId: event.sensorId,
      usernameThinger: event.usernameThinger,
    );

    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (user) => emit(const SignUpSuccessState('Pendaftaran berhasil! Silakan masuk.')),
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await signOutUseCase();
    final rememberResult = await getRememberMeUseCase();
    emit(Unauthenticated(rememberMe: rememberResult.getOrElse(() => false)));
  }

  Future<void> _onToggleRememberMe(
    ToggleRememberMeEvent event,
    Emitter<AuthState> emit,
  ) async {
    await setRememberMeUseCase(event.value);
    if (state is Unauthenticated) {
      final current = state as Unauthenticated;
      emit(Unauthenticated(
        rememberMe: event.value,
        savedEmail: current.savedEmail,
        savedPassword: current.savedPassword,
      ));
    }
  }

  Future<void> _onLoadSavedCredentials(
    LoadSavedCredentialsEvent event,
    Emitter<AuthState> emit,
  ) async {
    final rememberResult = await getRememberMeUseCase();
    final isRemembered = rememberResult.getOrElse(() => false);
    if (isRemembered) {
      final credResult = await getSavedCredentialsUseCase();
      final creds = credResult.getOrElse(() => {});
      emit(Unauthenticated(
        rememberMe: true,
        savedEmail: creds['email'],
        savedPassword: creds['password'],
      ));
    } else {
      emit(const Unauthenticated(rememberMe: false));
    }
  }
}
