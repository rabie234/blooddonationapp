import 'package:blood_donation_app/routes/app_routes.dart';
import 'package:blood_donation_app/utils/global_colors.dart';
import 'package:blood_donation_app/utils/translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BloodDonationApp extends StatelessWidget {
  final Map<String, Map<String, String>> translations;
  final String locale;

  BloodDonationApp({
    Key? key,
    required this.translations,
    required this.locale,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translationsKeys: translations,
      locale: Locale(locale),
      fallbackLocale: TranslationService.fallbackLocale,
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.routes,
      theme: ThemeData(
        primaryColor: GlobalColors.primaryColor,
        scaffoldBackgroundColor: GlobalColors.backgroundColor,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: GlobalColors.textColor),
          bodyMedium: TextStyle(color: GlobalColors.textColor),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: GlobalColors.primaryColor,
          secondary: GlobalColors.lightGray,
          background: GlobalColors.secondaryColor,
          error: GlobalColors.primaryColor,
        ),
        dialogBackgroundColor: GlobalColors.backgroundColor,
        dividerColor: GlobalColors.lightGray,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: GlobalColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: GlobalColors.primaryColor,
          titleTextStyle: TextStyle(color: GlobalColors.secondaryColor),
          iconTheme: IconThemeData(color: GlobalColors.secondaryColor),
        ),
      ),
    );
  }
}
