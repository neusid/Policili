import 'package:flutter/material.dart';
import 'input_field.dart';

class InputFieldShort extends StatelessWidget {
  const InputFieldShort({
    super.key,
    required this.label,
    this.isPassword = false,
    required this.controller,
    this.validator,
    this.hintText,
  });

  final String label;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return InputField(
      label: label,
      isPassword: isPassword,
      controller: controller,
      validator: validator,
      hintText: hintText,
    );
  }
}
