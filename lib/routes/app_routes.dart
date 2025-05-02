// filepath: c:\Users\ibrah\flutterproject\blooddonationapp\lib\routes\app_routes.dart
import 'package:blood_donation_app/views/screens/details_page.dart';
import 'package:blood_donation_app/views/screens/home_screen.dart';
import 'package:blood_donation_app/views/screens/notification_page.dart';
import 'package:blood_donation_app/views/screens/profile_screen.dart';
import 'package:blood_donation_app/views/screens/registration_screen/login_screen.dart';
import 'package:blood_donation_app/views/screens/registration_screen/signup_screen.dart';
import 'package:blood_donation_app/views/screens/registration_screen/verify_otp_screen.dart';
import 'package:blood_donation_app/views/screens/search_page.dart';
import 'package:blood_donation_app/views/screens/splash_screen.dart';
import 'package:blood_donation_app/views/screens/terms_and_conditions_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const initialRoute = '/splashScreen';

  static final routes = [
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/signup', page: () => SignupScreen()),
    GetPage(name: '/verify_otp', page: () => OTPVerificationScreen()),
    GetPage(name: '/profile', page: () => ProfileScreen()),
    GetPage(name: '/terms', page: () => TermsAndConditionsPage()),
    GetPage(name: '/search', page: () => SearchPage()),
    GetPage(name: '/notifications', page: () => NotificationPage()),
    GetPage(name: '/', page: () => SplashScreen()),
    GetPage(name: '/home', page: () => HomeScreen()),
    GetPage(
        name: '/details', page: () => DetailsPage()), // Add DetailsPage route
  ];
}
