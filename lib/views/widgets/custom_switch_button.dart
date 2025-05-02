import 'package:blood_donation_app/utils/global_colors.dart';
import 'package:flutter/material.dart';

/// Custom Switch Button Widget
class CustomSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: GlobalColors.textColor,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: GlobalColors.primaryColor,
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.shade300,
        ),
      ],
    );
  }
}
