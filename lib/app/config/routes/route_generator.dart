import 'package:flutter/material.dart';
import '../../../features/auth/presentation/pages/sign_in_page.dart';
import '../../../features/auth/presentation/pages/sign_up_page.dart';
import '../../../features/auth/presentation/pages/splash_page.dart';
import '../../../features/history/presentation/pages/history_page.dart';
import '../../../features/profile/presentation/pages/change_profile_page.dart';
import '../../../features/recommendation/presentation/pages/generate_page.dart';
import '../../../features/recommendation/presentation/pages/home_page.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.generate:
        return MaterialPageRoute(builder: (_) => const GeneratePage());
      case AppRoutes.history:
        return MaterialPageRoute(builder: (_) => const HistoryPage());
      case AppRoutes.changeProfile:
        return MaterialPageRoute(builder: (_) => const ChangeProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Rute ${settings.name} tidak ditemukan'),
            ),
          ),
        );
    }
  }
}
