import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Auth Feature
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/remember_me_usecases.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Profile Feature
import '../../features/profile/data/datasources/profile_local_data_source.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/profile_usecases.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';

// Recommendation Feature
import '../../features/recommendation/data/datasources/recommendation_local_data_source.dart';
import '../../features/recommendation/data/datasources/recommendation_remote_data_source.dart';
import '../../features/recommendation/data/repositories/recommendation_repository_impl.dart';
import '../../features/recommendation/domain/repositories/recommendation_repository.dart';
import '../../features/recommendation/domain/usecases/recommendation_usecases.dart';
import '../../features/recommendation/presentation/bloc/recommendation_bloc.dart';

// History Feature
import '../../features/history/data/datasources/history_remote_data_source.dart';
import '../../features/history/data/repositories/history_repository_impl.dart';
import '../../features/history/domain/repositories/history_repository.dart';
import '../../features/history/domain/usecases/get_prediction_history_usecase.dart';
import '../../features/history/presentation/bloc/history_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ----------------------------------------------------
  // External
  // ----------------------------------------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<fb.FirebaseAuth>(() => fb.FirebaseAuth.instance);

  // ----------------------------------------------------
  // Feature: Auth
  // ----------------------------------------------------
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      client: sl(),
    ),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => GetRememberMeUseCase(sl()));
  sl.registerLazySingleton(() => SetRememberMeUseCase(sl()));
  sl.registerLazySingleton(() => GetSavedCredentialsUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      getRememberMeUseCase: sl(),
      setRememberMeUseCase: sl(),
      getSavedCredentialsUseCase: sl(),
    ),
  );

  // ----------------------------------------------------
  // Feature: Profile
  // ----------------------------------------------------
  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(
      sharedPreferences: sl(),
      secureStorage: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetLocalSensorDataUseCase(sl()));
  sl.registerLazySingleton(() => SaveLocalSensorDataUseCase(sl()));
  sl.registerLazySingleton(() => SyncThingerTokenUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => ProfileBloc(
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
      getLocalSensorDataUseCase: sl(),
      saveLocalSensorDataUseCase: sl(),
      syncThingerTokenUseCase: sl(),
    ),
  );

  // ----------------------------------------------------
  // Feature: Recommendation
  // ----------------------------------------------------
  // Data sources
  sl.registerLazySingleton<RecommendationRemoteDataSource>(
    () => RecommendationRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<RecommendationLocalDataSource>(
    () => RecommendationLocalDataSourceImpl(
      sharedPreferences: sl(),
      secureStorage: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<RecommendationRepository>(
    () => RecommendationRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => FetchSensorDataUseCase(sl()));
  sl.registerLazySingleton(() => GetCropRecommendationUseCase(sl()));
  sl.registerLazySingleton(() => GetPlantDetailsUseCase(sl()));
  sl.registerLazySingleton(() => SavePredictionLogUseCase(sl()));
  sl.registerLazySingleton(() => GenerateFullRecommendationUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => RecommendationBloc(
      generateFullRecommendationUseCase: sl(),
    ),
  );

  // ----------------------------------------------------
  // Feature: History
  // ----------------------------------------------------
  // Data sources
  sl.registerLazySingleton<HistoryRemoteDataSource>(
    () => HistoryRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetPredictionHistoryUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => HistoryBloc(getPredictionHistoryUseCase: sl()),
  );
}
