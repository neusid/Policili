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
      _emailController.text = (authState.savedEmail != null && authState.savedEmail!.isNotEmpty)
          ? authState.savedEmail!
          : 'user@policili.com';
      _passwordController.text = (authState.savedPassword != null && authState.savedPassword!.isNotEmpty)
          ? authState.savedPassword!
          : '123456';
    } else {
      _emailController.text = 'user@policili.com';
      _passwordController.text = '123456';
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

    final finalEmail = email.isEmpty ? 'user@policili.com' : email;
    final finalPassword = password.isEmpty ? '123456' : password;

    context.read<AuthBloc>().add(SignInSubmittedEvent(
          email: finalEmail,
          password: finalPassword,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          UiHelpers.showSnackBar(
            context,
            title: 'Berhasil Masuk',
            message: 'Selamat datang kembali di Policili!',
          );
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        } else if (state is AuthFailureState) {
          UiHelpers.showSnackBar(
            context,
            title: 'Gagal Masuk',
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
                  SizedBox(height: 0.22.sh),

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

                  // Clean White Card Sheet
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
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 420),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Signature Policili Logo Box
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
                                SizedBox(height: 12.h),

                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Log in to your account",
                                        style: GoogleFonts.inter(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xff0F172A),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        "Welcome back! Please enter your details.",
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5.sp,
                                          color: const Color(0xff64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 28.h),

                                // Email Input (Bab 7 Standard)
                                InputField(
                                  label: "Email",
                                  controller: _emailController,
                                  hintText: "Enter your email",
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: 16.h),

                                // Password Input (Bab 7 Standard)
                                InputField(
                                  label: "Password",
                                  controller: _passwordController,
                                  isPassword: true,
                                  hintText: "••••••••",
                                ),
                                SizedBox(height: 12.h),

                                // Remember Me & Forgot Password
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 22.w,
                                          height: 22.w,
                                          child: Checkbox(
                                            value: isRemembered,
                                            activeColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4.r),
                                            ),
                                            onChanged: (bool? newValue) {
                                              context.read<AuthBloc>().add(
                                                    ToggleRememberMeEvent(
                                                        newValue ?? false),
                                                  );
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "Remember me",
                                          style: GoogleFonts.inter(
                                            fontSize: 13.sp,
                                            color: const Color(0xff475569),
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(4.r),
                                      onTap: () {
                                        UiHelpers.showSnackBar(
                                          context,
                                          message: "Fitur lupa sandi sedang disiapkan.",
                                        );
                                      },
                                      child: Text(
                                        "Forgot Password",
                                        style: GoogleFonts.inter(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue.shade600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 22.h),

                                // Signature Red Submit Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 48.h,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _onSignIn,
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
                                            "Sign in",
                                            style: GoogleFonts.inter(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(height: 12.h),

                                // Google Sign in Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 48.h,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      UiHelpers.showSnackBar(
                                        context,
                                        message: "Google Sign-In mode offline aktif.",
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Color(0xffE2E8F0)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/img/google.png",
                                          width: 18.w,
                                        ),
                                        SizedBox(width: 10.w),
                                        Text(
                                          "Sign in with Google",
                                          style: GoogleFonts.inter(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff1E293B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24.h),

                                // Sign Up Link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account?",
                                      style: GoogleFonts.inter(
                                        fontSize: 13.5.sp,
                                        color: const Color(0xff64748B),
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(AppRoutes.signUp);
                                      },
                                      child: Text(
                                        "Sign up",
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

              // Smooth Loading Overlay
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
