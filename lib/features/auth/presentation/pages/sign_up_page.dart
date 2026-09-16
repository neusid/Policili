import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../app/config/routes/app_routes.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/input_field.dart';
import '../../../../core/widgets/input_field_short.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _deviceIdController = TextEditingController();
  final TextEditingController _sensorIdController = TextEditingController();
  final TextEditingController _usernameThingerController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _deviceIdController.dispose();
    _sensorIdController.dispose();
    _usernameThingerController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final deviceId = _deviceIdController.text.trim();
    final sensorId = _sensorIdController.text.trim();
    final usernameThinger = _usernameThingerController.text.trim();

    if ([email, password, name, deviceId, sensorId, usernameThinger]
        .any((field) => field.isEmpty)) {
      UiHelpers.showSnackBar(
        context,
        message: 'Mohon lengkapi semua kolom pendaftaran',
        isError: true,
      );
      return;
    }

    context.read<AuthBloc>().add(SignUpSubmittedEvent(
          email: email,
          password: password,
          name: name,
          deviceId: deviceId,
          sensorId: sensorId,
          usernameThinger: usernameThinger,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignUpSuccessState) {
          UiHelpers.showSnackBar(
            context,
            title: 'Berhasil',
            message: state.message,
          );
          Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
        } else if (state is AuthFailureState) {
          UiHelpers.showSnackBar(
            context,
            title: 'Gagal Mendaftar',
            message: state.errorMessage,
            isError: true,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: const Color(0xffFF2020),
          body: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 0.25.sw),
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.r),
                          topRight: Radius.circular(40.r),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(width * 0.05),
                          child: Column(
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
                                      "Sign Up to create your account",
                                      style: TextStyle(
                                        fontSize: width * 0.05,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: width * 0.01),
                                    const Text(
                                      "Welcome! Please enter your details.",
                                    ),
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
                              InputField(
                                label: "Name",
                                controller: _nameController,
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InputFieldShort(
                                    label: "Device Name",
                                    controller: _deviceIdController,
                                  ),
                                  InputFieldShort(
                                    label: "Sensor Name",
                                    controller: _sensorIdController,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              InputField(
                                label: "Username Thinger",
                                controller: _usernameThingerController,
                              ),
                              SizedBox(height: 30.h),
                              SizedBox(
                                width: width * 1,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _onSignUp,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(width * 0.01),
                                    ),
                                    backgroundColor: const Color(0xffFF2020),
                                  ),
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Have an account?"),
                                  SizedBox(width: width * 0.01),
                                  Material(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(AppRoutes.signIn);
                                      },
                                      child: const Text(
                                        "Sign in",
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
                  width: double.infinity,
                  height: double.infinity,
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
