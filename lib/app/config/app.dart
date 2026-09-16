import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/di/injection_container.dart';
import '../../core/theme/app_theme.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/history/presentation/bloc/history_bloc.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/recommendation/presentation/bloc/recommendation_bloc.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';

class PoliciliApp extends StatelessWidget {
  const PoliciliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => sl<ProfileBloc>(),
        ),
        BlocProvider<RecommendationBloc>(
          create: (_) => sl<RecommendationBloc>(),
        ),
        BlocProvider<HistoryBloc>(
          create: (_) => sl<HistoryBloc>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Policili',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
