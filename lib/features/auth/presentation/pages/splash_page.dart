import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/config/routes/app_routes.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'sign_in_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        final navigator = Navigator.of(context);
        if (state is Authenticated) {
          Future.delayed(const Duration(milliseconds: 2500), () {
            if (mounted) {
              navigator.pushReplacementNamed(AppRoutes.home);
            }
          });
        } else if (state is Unauthenticated) {
          Future.delayed(const Duration(milliseconds: 2500), () {
            if (mounted) {
              navigator.pushReplacementNamed(AppRoutes.signIn);
            }
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: AnimatedSplashScreen(
            splash: Image.asset("assets/img/Logo.png"),
            splashIconSize: 0.4.sw,
            duration: 2500,
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white,
            nextScreen: const SignInPage(),
          ),
        ),
      ),
    );
  }
}
