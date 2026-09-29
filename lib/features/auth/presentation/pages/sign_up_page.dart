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
        message: 'Mohon lengkapi semua data pendaftaran & perangkat IoT.',
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
            title: 'Pendaftaran Berhasil',
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
          body: Stack(
            children: [
              // Hero Brand Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 240,
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
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Image.asset("assets/img/Logo.png"),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Policili",
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            "Buat Akun Baru",
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Daftarkan akun dan hubungkan sensor IoT pertanian Anda",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Form Card
              Positioned.fill(
                top: 205,
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
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section: Data Akun
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_outline_rounded,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Informasi Pribadi",
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            InputField(
                              label: "Nama Lengkap",
                              controller: _nameController,
                              hintText: "Nama Anda",
                              prefixIcon: const Icon(
                                Icons.badge_outlined,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 14),
                            InputField(
                              label: "Alamat Email",
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
                              hintText: "Minimal 6 karakter",
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Section: Integrasi IoT
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.emeraldSurface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.emerald.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.sensors_rounded,
                                        color: AppColors.emeraldDark,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Konfigurasi Perangkat IoT",
                                        style: GoogleFonts.inter(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.emeraldDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Masukkan kredensial perangkat Thinger.io Anda",
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  InputField(
                                    label: "Username Thinger.io",
                                    controller: _usernameThingerController,
                                    hintText: "Username akun Thinger.io",
                                    prefixIcon: const Icon(
                                      Icons.account_circle_outlined,
                                      color: AppColors.textMuted,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
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
                                ],
                              ),
                            ),
                            const SizedBox(height: 26),

                            // Submit CTA
                            PoliciliButton(
                              text: "Daftar Akun",
                              isLoading: isLoading,
                              onPressed: _onSignUp,
                            ),
                            const SizedBox(height: 20),

                            // Back to sign in
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Sudah memiliki akun?",
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
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
