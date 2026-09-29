import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/config/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/input_field.dart';
import '../../../../core/widgets/policili_button.dart';
import 'package:policili_apps/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:policili_apps/features/auth/presentation/bloc/auth_event.dart';
import 'package:policili_apps/features/auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/external_user_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ChangeProfilePage extends StatefulWidget {
  const ChangeProfilePage({
    super.key,
    this.showBackButton = true,
  });

  final bool showBackButton;

  @override
  State<ChangeProfilePage> createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _deviceController = TextEditingController();
  final TextEditingController _sensorController = TextEditingController();
  final TextEditingController _usernameThingerController = TextEditingController();

  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _userEmail = authState.user.email;
    }
    context.read<ProfileBloc>().add(LoadProfileEvent(_userEmail));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _deviceController.dispose();
    _sensorController.dispose();
    _usernameThingerController.dispose();
    super.dispose();
  }

  void _onSaveProfile() {
    final name = _nameController.text.trim();
    final deviceId = _deviceController.text.trim();
    final sensorId = _sensorController.text.trim();
    final usernameThinger = _usernameThingerController.text.trim();

    if ([name, deviceId, sensorId, usernameThinger].any((f) => f.isEmpty)) {
      UiHelpers.showSnackBar(
        context,
        message: 'Mohon lengkapi semua kolom profil dan IoT',
        isError: true,
      );
      return;
    }

    final user = ExternalUserEntity(
      name: name,
      email: _userEmail,
      deviceId: deviceId,
      sensorId: sensorId,
      usernameThinger: usernameThinger,
    );

    context.read<ProfileBloc>().add(UpdateProfileEvent(user));
  }

  void _onSignOut() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Konfirmasi Keluar",
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          "Apakah Anda yakin ingin keluar dari akun Policili?",
          style: GoogleFonts.inter(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(90, 40),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AuthBloc>().add(SignOutRequestedEvent());
            },
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.signIn,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            "Profil & Perangkat IoT",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: true,
          leading: widget.showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, size: 18),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              _nameController.text = state.user.name;
              _deviceController.text = state.user.deviceId;
              _sensorController.text = state.user.sensorId;
              _usernameThingerController.text = state.user.usernameThinger;
            } else if (state is ProfileUpdateSuccess) {
              UiHelpers.showSnackBar(
                context,
                title: 'Berhasil',
                message: state.message,
              );
            } else if (state is ProfileFailure) {
              UiHelpers.showSnackBar(
                context,
                title: 'Gagal',
                message: state.errorMessage,
                isError: true,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ProfileLoading;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Identity Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.primary, AppColors.secondary],
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _nameController.text.isNotEmpty
                                        ? _nameController.text
                                        : "Petani Policili",
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _userEmail.isNotEmpty ? _userEmail : "-",
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.emeraldSurface,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "IoT Node Terdaftar",
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.emeraldDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section: Akun Pribadi
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.badge_outlined,
                                  size: 18,
                                  color: AppColors.primary,
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
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section: Kredensial Perangkat IoT (Thinger.io)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.sensors_rounded,
                                  size: 18,
                                  color: AppColors.emeraldDark,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Integrasi Sensor Thinger.io",
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Digunakan oleh mesin AI untuk menarik telemetri real-time tanah dan suhu tanaman cabai.",
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
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
                            const SizedBox(height: 14),
                            InputField(
                              label: "Device ID",
                              controller: _deviceController,
                              hintText: "ID Perangkat IoT",
                              prefixIcon: const Icon(
                                Icons.router_outlined,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 14),
                            InputField(
                              label: "Sensor Resource ID",
                              controller: _sensorController,
                              hintText: "Nama resource sensor",
                              prefixIcon: const Icon(
                                Icons.memory_outlined,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Save CTA
                      PoliciliButton(
                        text: "Simpan Konfigurasi",
                        isLoading: isLoading,
                        onPressed: _onSaveProfile,
                      ),
                      const SizedBox(height: 14),

                      // Sign Out Button
                      PoliciliButton(
                        text: "Keluar dari Akun",
                        isOutlined: true,
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        onPressed: _onSignOut,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
