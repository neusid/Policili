import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/external_user_entity.dart';
import '../../domain/usecases/profile_usecases.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final GetLocalSensorDataUseCase getLocalSensorDataUseCase;
  final SaveLocalSensorDataUseCase saveLocalSensorDataUseCase;
  final SyncThingerTokenUseCase syncThingerTokenUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.getLocalSensorDataUseCase,
    required this.saveLocalSensorDataUseCase,
    required this.syncThingerTokenUseCase,
  }) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<SyncThingerTokenEvent>(_onSyncThingerToken);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    // Coba ambil dari local terlebih dahulu
    final localResult = await getLocalSensorDataUseCase();
    ExternalUserEntity? cachedUser;
    localResult.fold((_) {}, (user) => cachedUser = user);

    if (event.email != null && event.email!.isNotEmpty) {
      final remoteResult = await getProfileUseCase(event.email!);
      remoteResult.fold(
        (failure) {
          if (cachedUser != null) {
            emit(ProfileLoaded(cachedUser!));
          } else {
            emit(ProfileFailure(failure.message));
          }
        },
        (user) {
          emit(ProfileLoaded(user));
        },
      );
    } else if (cachedUser != null) {
      emit(ProfileLoaded(cachedUser!));
    } else {
      emit(const ProfileFailure('Tidak ada data profil'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await updateProfileUseCase(event.user);

    await result.fold(
      (failure) async => emit(ProfileFailure(failure.message)),
      (response) async {
        await saveLocalSensorDataUseCase(event.user);
        emit(ProfileUpdateSuccess('Profil berhasil diperbarui!', event.user));
      },
    );
  }

  Future<void> _onSyncThingerToken(
    SyncThingerTokenEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await syncThingerTokenUseCase();
  }
}
