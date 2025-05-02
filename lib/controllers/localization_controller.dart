import 'package:blood_donation_app/l10n/appLocal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController {
  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _localization.init(
      mapLocales: [
        const MapLocale(
          'en',
          AppLocale.EN,
          countryCode: 'US',
          fontFamily: 'Font EN',
        ),
        const MapLocale(
          'ar',
          AppLocale.AR,
          countryCode: 'LB',
          fontFamily: 'Font AR',
        ),
      ],
      initLanguageCode: 'en',
    );
    _localization.onTranslatedLanguage = _changeLanguage;
  }

  void _changeLanguage(lg) {
    _localization.translate(lg);
  }
}
