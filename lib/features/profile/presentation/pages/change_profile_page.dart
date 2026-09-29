import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../app/config/routes/app_routes.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/input_field.dart';
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
        message: 'Mohon lengkapi semua data profil dan IoT',
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Keluar Akun",
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16.sp),
        ),
        content: Text(
          "Apakah Anda yakin ingin keluar dari akun?",
          style: GoogleFonts.inter(fontSize: 13.5.sp, color: const Color(0xff475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffFF2020),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
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
      child: BlocConsumer<ProfileBloc, ProfileState>(
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

          return Scaffold(
            backgroundColor: const Color(0xffFF2020),
            body: Stack(
              children: [
                // Authentic Top Red Banner with bg_card.png
                Container(
                  width: double.infinity,
                  height: 0.95.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15.w),
                      bottomLeft: Radius.circular(15.w),
                    ),
                    image: const DecorationImage(
                      image: AssetImage("assets/img/bg_card.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // Top Navigation Header
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        child: Row(
                          children: [
                            if (widget.showBackButton && Navigator.canPop(context))
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  width: 44.w,
                                  height: 44.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffD9D9D9),
                                    borderRadius: BorderRadius.circular(10.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Color(0xff1E293B),
                                  ),
                                ),
                              ),
                            SizedBox(width: 14.w),
                            Text(
                              "Change Profile",
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Signature Arched Tab Accent
                      Container(
                        width: 280.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(36.r),
                            topRight: Radius.circular(36.r),
                          ),
                        ),
                      ),

                      // Signature White Sheet Container
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 24.h,
                            ),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 420),
                                child: Column(
                                  children: [
                                    // Authentic Logo Container Box
                                    Container(
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
                                    SizedBox(height: 12.h),

                                    Text(
                                      "Change Profile",
                                      style: GoogleFonts.inter(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xff0F172A),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "Make changes to your profile here.",
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5.sp,
                                        color: const Color(0xff64748B),
                                      ),
                                    ),
                                    SizedBox(height: 28.h),

                                    // Name Field
                                    InputField(
                                      label: "Name",
                                      controller: _nameController,
                                      hintText: "Enter your name",
                                    ),
                                    SizedBox(height: 16.h),

                                    // Device Name & Sensor Name Row
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InputField(
                                            label: "Device Name",
                                            controller: _deviceController,
                                            hintText: "Device ID",
                                          ),
                                        ),
                                        SizedBox(width: 14.w),
                                        Expanded(
                                          child: InputField(
                                            label: "Sensor Name",
                                            controller: _sensorController,
                                            hintText: "Sensor ID",
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.h),

                                    // Username Thinger
                                    InputField(
                                      label: "Username Thinger",
                                      controller: _usernameThingerController,
                                      hintText: "Thinger username",
                                    ),
                                    SizedBox(height: 28.h),

                                    // Change Profile Button
                                    SizedBox(
                                      width: double.infinity,
                                      height: 48.h,
                                      child: ElevatedButton(
                                        onPressed: isLoading ? null : _onSaveProfile,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xffFF2020),
                                          foregroundColor: Colors.white,
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
                                                "Change Profile",
                                                style: GoogleFonts.inter(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(height: 14.h),

                                    // Sign Out Button
                                    SizedBox(
                                      width: double.infinity,
                                      height: 48.h,
                                      child: OutlinedButton(
                                        onPressed: _onSignOut,
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Color(0xffCBD5E1)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                        child: Text(
                                          "Keluar Akun",
                                          style: GoogleFonts.inter(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xffDC2626),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
      ),
    );
  }
}
