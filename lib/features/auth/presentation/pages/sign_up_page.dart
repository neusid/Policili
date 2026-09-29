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
  final TextEditingController _usernameThingerController =
      TextEditingController();

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
        message: 'Mohon lengkapi seluruh kolom pendaftaran',
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
            title: 'Berhasil Mendaftar',
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
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 18),
              ),
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed(AppRoutes.signIn),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    children: [
                      // Form Card with Symmetrical Padding
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pendaftaran Akun Baru",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Daftarkan akun dan hubungkan sensor IoT Anda.",
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 20),

                            InputField(
                              label: "Nama Lengkap",
                              controller: _nameController,
                              hintText: "Nama Anda",
                              prefixIcon: const Icon(
                                Icons.person_outline_rounded,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 14),

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
                            const SizedBox(height: 14),

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

                            Row(
                              children: [
                                Expanded(
                                  child: InputField(
                                    label: "Device ID",
                                    controller: _deviceIdController,
                                    hintText: "ID Perangkat",
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: InputField(
                                    label: "Sensor ID",
                                    controller: _sensorIdController,
                                    hintText: "ID Sensor",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            InputField(
                              label: "Username Thinger.io",
                              controller: _usernameThingerController,
                              hintText: "Username akun Thinger",
                              prefixIcon: const Icon(
                                Icons.cloud_outlined,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 24),

                            PoliciliButton(
                              text: "Daftar Sekarang",
                              isLoading: isLoading,
                              onPressed: _onSignUp,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Sign In redirect
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sudah memiliki akun?",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoutes.signIn);
                            },
                            child: Text(
                              "Masuk",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
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
        );
      },
    );
  }
}
