import 'package:blood_donation_app/utils/global_colors.dart';
import 'package:flutter/material.dart';

/// Custom Button Widget
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final bool isLoading; // New property to handle loading state

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.isLoading = false, // Default value is false
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isLoading
            ? Colors.grey // Disable button with grey color when loading
            : color ?? GlobalColors.buttonColor,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: isLoading ? null : onPressed, // Disable button when loading
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: textColor ?? GlobalColors.secondaryColor,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: TextStyle(
                color: textColor ?? GlobalColors.secondaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
