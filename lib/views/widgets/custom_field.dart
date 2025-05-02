import 'package:blood_donation_app/utils/global_colors.dart';
import 'package:flutter/material.dart';

/// Custom Input Field Widget
class CustomInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool readOnly;

  const CustomInputField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap, // Initialize onTap
    this.readOnly = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly, // Set the readOnly property
      onTap: onTap, // Trigger the onTap callback if provided
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: GlobalColors.textColor.withOpacity(0.6), // Subtle hint color
          fontSize: 14,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: GlobalColors.primaryColor)
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: GlobalColors.lightGray, // Background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none, // No border by default
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius:
              BorderRadius.circular(10), // Remove border when not focused
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: GlobalColors.primaryColor, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ), // Adjust padding
      ),
      style: TextStyle(
        fontSize: 16,
        color: GlobalColors.textColor, // Text color
      ),
    );
  }
}
