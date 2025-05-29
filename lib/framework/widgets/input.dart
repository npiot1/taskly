import 'package:flutter/material.dart';
import 'package:taskly/framework/constants/app_style.dart';
import 'package:taskly/framework/widgets/password_field.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final bool obscureText;
  final double? textSize;
  final bool isPassword;

  const CustomTextInput({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.obscureText = false,
    this.textSize = AppFontSize.MEDIUM_PLUS_TEXT,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: textSize!.toDouble(),
              fontWeight: FontWeight.bold,
            ),

          ),
          const SizedBox(height: 8),
        ],
        isPassword ? PasswordField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hintText,
          ),
        ) : TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
