import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../app/config/routes/app_routes.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/input_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Unauthenticated) {
      if (authState.savedEmail != null) {
        _emailController.text = authState.savedEmail!;
      }
      if (authState.savedPassword != null) {
        _passwordController.text = authState.savedPassword!;
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      UiHelpers.showSnackBar(
        context,
        message: 'Mohon isi email dan password',
        isError: true,
      );
      return;
    }

    context.read<AuthBloc>().add(SignInSubmittedEvent(
          email: email,
          password: password,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          UiHelpers.showSnackBar(
            context,
            title: 'Berhasil',
            message: 'Login berhasil',
          );
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        } else if (state is AuthFailureState) {
          UiHelpers.showSnackBar(
            context,
            title: 'Gagal',
            message: state.errorMessage,
            isError: true,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final isRemembered = state is Unauthenticated ? state.rememberMe : false;

        return Scaffold(
          backgroundColor: const Color(0xffD52424),
          body: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 0.6.sw),
                  Container(
                    width: 280.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 1.sw,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.r),
                          topRight: Radius.circular(40.r),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),
                              Center(
                                child: Container(
                                  width: 30.w,
                                  height: 30.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.w),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10.w,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(3.w),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(5.w),
                                      ),
                                      child: Image.asset("assets/img/Logo.png"),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Log in to your account",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    const Text("Welcome back! Please enter your details."),
                                  ],
                                ),
                              ),
                              SizedBox(height: 40.h),
                              InputField(
                                label: "Email",
                                controller: _emailController,
                              ),
                              SizedBox(height: 10.h),
                              InputField(
                                label: "Password",
                                controller: _passwordController,
                                isPassword: true,
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                        value: isRemembered,
                                        checkColor: Colors.white,
                                        activeColor: Colors.blue,
                                        onChanged: (bool? newValue) {
                                          context.read<AuthBloc>().add(
                                                ToggleRememberMeEvent(
                                                    newValue ?? false),
                                              );
                                        },
                                      ),
                                      const Text("Remember me"),
                                    ],
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(4.r),
                                    splashColor: Colors.blue.withOpacity(0.3),
                                    onTap: () {},
                                    child: const Text(
                                      "Forgot Password",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              SizedBox(
                                width: 1.sw,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _onSignIn,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    backgroundColor: const Color(0xffFF2020),
                                  ),
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              SizedBox(
                                width: 1.sw,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.r),
                                      side: const BorderSide(color: Colors.black12),
                                    ),
                                    backgroundColor: const Color(0xffFFFFFF),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/img/google.png",
                                        width: 16.w,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "Sign in with Google",
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account?"),
                                  SizedBox(width: 5.w),
                                  Material(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(AppRoutes.signUp);
                                      },
                                      child: const Text(
                                        "Sign up",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.red,
                      size: 50.w,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
