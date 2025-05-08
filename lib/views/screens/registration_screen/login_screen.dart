import 'package:blood_donation_app/controllers/registration_controller/login_controller.dart';
import 'package:blood_donation_app/utils/global_colors.dart';
import 'package:blood_donation_app/views/widgets/custom_button.dart';
import 'package:blood_donation_app/views/widgets/custom_field.dart';
import 'package:blood_donation_app/views/widgets/socila_buttons_register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: use_key_in_widget_constructors
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = Get.put(LoginController());

  @override
  void initState() {
    controller.identifierController = TextEditingController();
    controller.passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.identifierController.dispose();
    controller.passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'login'.tr,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "login_subtitle".tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GlobalColors.accentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CustomInputField(
                  hintText: 'email_username'.tr,
                  controller: controller.identifierController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                ),
                SizedBox(height: 15),
                CustomInputField(
                  hintText: 'password'.tr,
                  controller: controller.passwordController,
                  obscureText: true,
                  prefixIcon: Icons.lock,
                ),
                SizedBox(height: 20),
                Obx(() => CustomButton(
                      text: 'login'.tr,
                      isLoading: controller.isLoading.value,
                      onPressed: controller.login,
                    )),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'dont_have_account'.tr,
                      style: TextStyle(color: GlobalColors.textColor),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/signup');
                      },
                      child: Text(
                        'sign_up'.tr,
                        style: TextStyle(color: GlobalColors.primaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GoogleLoginButton(),
                SizedBox(height: 10),
                // FacebookLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
