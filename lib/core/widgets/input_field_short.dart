import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputFieldShort extends StatelessWidget {
  const InputFieldShort({
    super.key,
    required this.label,
    this.isPassword = false,
    required this.controller,
    this.validator,
  });

  final String label;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 5.w),
        SizedBox(
          width: 160.w,
          height: 45.w,
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            validator: validator,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(width * 0.1),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black12,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(width * 0.015),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(width * 0.015),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(width * 0.015),
              ),
              hintText: 'Enter your $label',
              hintStyle: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0.028.sh,
                horizontal: 0.05.sw,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
