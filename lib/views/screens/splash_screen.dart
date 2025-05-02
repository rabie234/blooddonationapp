import 'package:blood_donation_app/controllers/user_controller.dart';
import 'package:blood_donation_app/utils/global_colors.dart';
import 'package:blood_donation_app/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check for token and navigate accordingly
    Future.delayed(Duration(seconds: 3), () async {
      final token = await SharedPreferencesHelper.getString('token');
      if (token != null) {
        // Token exists, fetch user info
        final userController = Get.put(UserController());
        bool isLoged = await userController.getUser();
        if (!isLoged) {
          // If user is not logged in, navigate to the login screen
          Get.offNamed('/login');
        }
      } else {
        // No token, navigate to the signup screen
        Get.offNamed('/signup');
      }
    });

    return Scaffold(
      backgroundColor: GlobalColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bloodtype,
              size: 100,
              color: GlobalColors.secondaryColor,
            ),
            SizedBox(height: 20),
            Text(
              'welcome'.tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: GlobalColors.secondaryColor,
              ),
            ),
            SizedBox(height: 10),
            SpinKitChasingDots(
              color: GlobalColors.backgroundColor,
              size: 40.0,
            ),
          ],
        ),
      ),
    );
  }
}
