import 'package:blood_donation_app/utils/global_colors.dart';
import 'package:blood_donation_app/views/widgets/custom_button.dart';
import 'package:blood_donation_app/views/widgets/custom_field.dart';
import 'package:blood_donation_app/views/widgets/custom_snackbar.dart';
import 'package:blood_donation_app/views/widgets/custom_switch_button.dart';
import 'package:blood_donation_app/views/widgets/socila_buttons_register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blood_donation_app/controllers/registration_controller/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());
    final RxBool isPasswordVisible = false.obs; // State for password visibility
    final RxBool isConfirmPasswordVisible =
        false.obs; // State for confirm password visibility
    final RxBool isTermsAccepted = false.obs; // State for terms acceptance

    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'sign_up'.tr,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: GlobalColors.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "signup_subtitle".tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GlobalColors.accentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CustomInputField(
                  hintText: 'username'.tr,
                  controller: controller.usernameController,
                  keyboardType: TextInputType.name,
                  prefixIcon: Icons.person,
                ),
                SizedBox(height: 15),
                CustomInputField(
                  hintText: 'email'.tr,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                ),
                SizedBox(height: 15),
                Obx(() => CustomInputField(
                      hintText: 'password'.tr,
                      controller: controller.passwordController,
                      obscureText: !isPasswordVisible.value,
                      prefixIcon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: GlobalColors.textColor,
                        ),
                        onPressed: () {
                          isPasswordVisible.value = !isPasswordVisible.value;
                        },
                      ),
                    )),
                SizedBox(height: 15),
                Obx(() => CustomInputField(
                      hintText: 'confirm_password'.tr,
                      controller: controller.confirmPasswordController,
                      obscureText: !isConfirmPasswordVisible.value,
                      prefixIcon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: GlobalColors.textColor,
                        ),
                        onPressed: () {
                          isConfirmPasswordVisible.value =
                              !isConfirmPasswordVisible.value;
                        },
                      ),
                    )),
                SizedBox(height: 20),
                Obx(() => CustomSwitch(
                      label: 'are_you_donor'.tr,
                      value: controller.isDonor.value,
                      onChanged: controller.toggleDonor,
                    )),
                SizedBox(height: 20),

                // Terms and Conditions Checkbox
                Obx(() => Row(
                      children: [
                        Checkbox(
                          value: isTermsAccepted.value,
                          onChanged: (value) {
                            isTermsAccepted.value = value ?? false;
                          },
                          activeColor: GlobalColors.primaryColor,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed('/terms'); // Navigate to Terms Page
                            },
                            child: Text(
                              'agree_terms'.tr,
                              style: TextStyle(
                                color: GlobalColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 20),

                // Sign Up Button
                Obx(() => CustomButton(
                      isLoading: controller.isLoading.value,
                      text: 'sign_up'.tr,
                      onPressed: isTermsAccepted.value
                          ? controller.signUp
                          : () {
                              CustomSnackbar.show(
                                  isError: true,
                                  title: 'error'.tr,
                                  message: 'error_terms_required'.tr);
                            },
                    )),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'already_have_account'.tr,
                      style: TextStyle(color: GlobalColors.textColor),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/login');
                      },
                      child: Text(
                        'login'.tr,
                        style: TextStyle(color: GlobalColors.primaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Obx(() => GoogleLoginButton(isDonor: controller.isDonor.value)),
                SizedBox(height: 10),
                //  Obx(() =>FacebookLoginButton(isDonor: controller.isDonor.value)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
