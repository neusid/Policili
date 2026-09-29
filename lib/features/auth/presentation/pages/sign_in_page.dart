import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/config/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/input_field.dart';
import '../../../../core/widgets/policili_button.dart';
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
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Hero Brand Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 280,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Image.asset("assets/img/Logo.png"),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Policili",
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            "Selamat Datang Kembali",
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Masuk untuk memantau tanaman cabai dan sensor IoT",
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Form Card Container
              Positioned.fill(
                top: 240,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputField(
                              label: "Email",
                              controller: _emailController,
                              hintText: "nama@policili.com",
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(
                                Icons.mail_outline_rounded,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 18),
                            InputField(
                              label: "Kata Sandi",
                              controller: _passwordController,
                              isPassword: true,
                              hintText: "••••••••",
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Remember Me & Forgot Password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: isRemembered,
                                        activeColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        onChanged: (bool? newValue) {
                                          context.read<AuthBloc>().add(
                                                ToggleRememberMeEvent(
                                                    newValue ?? false),
                                              );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Ingat Saya",
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    UiHelpers.showSnackBar(
                                      context,
                                      message: "Silakan hubungi admin untuk reset kata sandi.",
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    "Lupa Sandi?",
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Primary CTA
                            PoliciliButton(
                              text: "Masuk ke Akun",
                              isLoading: isLoading,
                              onPressed: _onSignIn,
                            ),
                            const SizedBox(height: 16),

                            // Google Sign In Button
                            PoliciliButton(
                              text: "Masuk dengan Google",
                              isOutlined: true,
                              icon: Image.asset(
                                "assets/img/google.png",
                                width: 20,
                                height: 20,
                              ),
                              onPressed: () {
                                UiHelpers.showSnackBar(
                                  context,
                                  message: "Fitur Google Sign-In sedang disiapkan.",
                                );
                              },
                            ),
                            const SizedBox(height: 28),

                            // Sign Up Redirect
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Belum memiliki akun?",
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed(AppRoutes.signUp);
                                  },
                                  child: Text(
                                    "Daftar Sekarang",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
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
