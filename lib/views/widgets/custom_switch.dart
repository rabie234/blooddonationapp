import 'package:flutter/material.dart';
import 'package:blood_donation_app/utils/global_colors.dart';

class CustomSwitch extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool value;
  final bool warningDescription;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    Key? key,
    required this.title,
    required this.description,
    this.warningDescription = false,
    required this.icon,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            description,
            style: TextStyle(
                fontSize: 13,
                color: warningDescription
                    ? GlobalColors.primaryColor
                    : Colors.grey),
          ),
        ],
      ),
      leading: Icon(icon, color: GlobalColors.primaryColor),
      trailing: Switch(
        activeColor: GlobalColors.backgroundColor,
        inactiveThumbColor: GlobalColors.accentColor,
        inactiveTrackColor: GlobalColors.lightGray,
        activeTrackColor: GlobalColors.primaryColor,
        // trackColor: MaterialStateProperty.all(GlobalColors.primaryColor),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
