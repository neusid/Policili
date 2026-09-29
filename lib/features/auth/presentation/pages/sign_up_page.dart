import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../app/config/routes/app_routes.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/input_field.dart';
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
                  SizedBox(height: 0.12.sh),

                  // Signature floating curved tab accent
                  Container(
                    width: 280.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.r),
                        topRight: Radius.circular(32.r),
                      ),
                    ),
                  ),

                  // White Card Sheet
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36.r),
                          topRight: Radius.circular(36.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 20,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 420),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Logo
                                Center(
                                  child: Container(
                                    width: 44.w,
                                    height: 44.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.12),
                                          blurRadius: 10.w,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(6.w),
                                    child: Image.asset("assets/img/Logo.png"),
                                  ),
                                ),
                                SizedBox(height: 10.h),

                                Center(
                                  child: Text(
                                    "Create an account",
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff0F172A),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),

                                InputField(
                                  label: "Name",
                                  controller: _nameController,
                                  hintText: "Enter your name",
                                ),
                                SizedBox(height: 12.h),

                                InputField(
                                  label: "Email",
                                  controller: _emailController,
                                  hintText: "Enter your email",
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: 12.h),

                                InputField(
                                  label: "Password",
                                  controller: _passwordController,
                                  isPassword: true,
                                  hintText: "••••••••",
                                ),
                                SizedBox(height: 12.h),

                                Row(
                                  children: [
                                    Expanded(
                                      child: InputField(
                                        label: "Device ID",
                                        controller: _deviceIdController,
                                        hintText: "Device ID",
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: InputField(
                                        label: "Sensor ID",
                                        controller: _sensorIdController,
                                        hintText: "Sensor ID",
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),

                                InputField(
                                  label: "Username Thinger",
                                  controller: _usernameThingerController,
                                  hintText: "Enter your username thinger",
                                ),
                                SizedBox(height: 22.h),

                                // Red Submit Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 48.h,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _onSignUp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xffFF2020),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : Text(
                                            "Sign up",
                                            style: GoogleFonts.inter(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(height: 18.h),

                                // Sign in redirect
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account?",
                                      style: GoogleFonts.inter(
                                        fontSize: 13.5.sp,
                                        color: const Color(0xff64748B),
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(AppRoutes.signIn);
                                      },
                                      child: Text(
                                        "Sign in",
                                        style: GoogleFonts.inter(
                                          fontSize: 13.5.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.blue.shade600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              if (isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.35),
                  child: Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.white,
                      size: 44.w,
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
