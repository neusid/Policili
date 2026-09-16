import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/input_field.dart';
import '../../../../core/widgets/input_field_short.dart';
import 'package:policili_apps/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:policili_apps/features/auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/external_user_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ChangeProfilePage extends StatefulWidget {
  const ChangeProfilePage({super.key});

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
        message: 'Mohon lengkapi semua kolom profil',
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return BlocConsumer<ProfileBloc, ProfileState>(
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
              Container(
                width: double.infinity,
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
                height: 0.95.sw,
              ),
              Column(
                children: [
                  SizedBox(height: 0.1.sw),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 0.13.sw,
                            height: 0.13.sw,
                            decoration: BoxDecoration(
                              color: const Color(0xffD9D9D9),
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.2.sw),
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
                                      "Change Profile",
                                      style: TextStyle(
                                        fontSize: width * 0.05,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: width * 0.01),
                                    const Text(
                                      "Make changes to your profile here.",
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 40.h),
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
                                    controller: _deviceController,
                                  ),
                                  InputFieldShort(
                                    label: "Sensor Name",
                                    controller: _sensorController,
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
                                  onPressed: isLoading ? null : _onSaveProfile,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(width * 0.01),
                                    ),
                                    backgroundColor: const Color(0xffFF2020),
                                  ),
                                  child: Text(
                                    "Change Profile",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
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
