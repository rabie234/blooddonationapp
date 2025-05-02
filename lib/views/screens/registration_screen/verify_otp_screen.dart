import 'package:blood_donation_app/controllers/registration_controller/signup_controller.dart';
import 'package:blood_donation_app/utils/global_colors.dart';
import 'package:blood_donation_app/views/widgets/custom_button.dart';
import 'package:blood_donation_app/views/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTPVerificationScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();
  final SignupController signupController = Get.find<SignupController>();

  OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('otp_verification'.tr),
        backgroundColor: GlobalColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'enter_otp_instruction'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: GlobalColors.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            CustomInputField(
              hintText: 'enter_otp'.tr,
              controller: otpController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.lock,
            ),
            SizedBox(height: 20),
            Obx(() => CustomButton(
                  text: signupController.isLoading.value
                      ? 'verifying'.tr
                      : 'verify_otp'.tr,
                  isLoading: signupController.isLoading.value,
                  onPressed: () async {
                    String otp = otpController.text.trim();

                    if (otp.isEmpty) {
                      Get.snackbar(
                        'error'.tr,
                        'empty_otp_message'.tr,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    signupController.verifyOTP(otp);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
