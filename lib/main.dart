import 'package:blood_donation_app/app.dart';
import 'package:blood_donation_app/controllers/user_controller.dart';
import 'package:blood_donation_app/utils/translations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
//
void requestPermissions() async {
  await [
    Permission.location,
    Permission.notification,
  ].request();
}

/// Global SharedPreferences Instance
late final SharedPreferences globalPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final translations = await TranslationService.loadTranslations();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("17b7a5b8-463c-4e08-9639-87a1081509ec");
  OneSignal.Notifications.requestPermission(true);

  globalPrefs = await SharedPreferences.getInstance();
  String langCode = globalPrefs.getString('lang') ?? 'en'; // default to English

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("🔥 Firebase failed to initialize: $e");
  }

  Get.put(UserController());
  requestPermissions();
  runApp(BloodDonationApp(
    translations: translations,
    locale: langCode,
  ));
}
