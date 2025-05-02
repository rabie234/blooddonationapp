import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TranslationService extends Translations {
  static final fallbackLocale = const Locale('en');

  static Future<Map<String, Map<String, String>>> loadTranslations() async {
    final supportedLocales = ['en', 'ar'];
    Map<String, Map<String, String>> translations = {};

    for (String locale in supportedLocales) {
      String jsonString =
          await rootBundle.loadString('assets/lang/$locale.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      translations[locale] =
          jsonMap.map((key, value) => MapEntry(key, value.toString()));
    }

    return translations;
  }

  @override
  Map<String, Map<String, String>> get keys => {};
}
