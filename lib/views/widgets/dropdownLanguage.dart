import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: Get.locale, // Current locale
      icon: Icon(Icons.language, color: Colors.black),
      underline: SizedBox(),
      items: [
        DropdownMenuItem(
          value: const Locale('en'),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: const Locale('ar'),
          child: Text('العربية'),
        ),
      ],
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          Get.updateLocale(newLocale);
        }
      },
    );
  }
}
