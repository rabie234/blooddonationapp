import 'dart:convert';
import 'dart:developer';
import 'package:blood_donation_app/controllers/user_controller.dart';
import 'package:blood_donation_app/utils/location_getter.dart';
import 'package:blood_donation_app/utils/shared_preferences_helper.dart';
import 'package:blood_donation_app/views/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blood_donation_app/utils/http_helper.dart';

class SignupController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  Map<String, dynamic>? tempSignupData;

  var isDonor = false.obs; // Observable for the donor switch
  var isLoading = false.obs;
  final HttpHelper httpHelper =
      HttpHelper(); // Create an instance of HttpHelper

  void toggleDonor(bool value) {
    isDonor.value = value;
  }

  Future<bool> verifyOTP(String otp) async {
    try {
      isLoading.value = true; // Set loading state to true

      // Include the OTP in the request body along with the saved sign-up data
      final body = {
        ...?tempSignupData, // Spread the saved sign-up data
        'otp': otp, // Add the OTP to the request body
        'is_donor': tempSignupData?['isDonor']
      };

      // Send the POST request to verify OTP
      final response =
          await httpHelper.post('/auth/verifyRegistrationOTP', body);
      final responseJson = jsonDecode(response.body);

      isLoading.value = false; // Set loading state to false

      if (responseJson['success'] == true) {
        // Save the token to SharedPreferences

        await SharedPreferencesHelper.saveString(
            'token', responseJson['data']['token']);

        // Fetch user information
        final userController = Get.find<UserController>();
        await userController.getUser();

        return true; // OTP verification successful
      } else {
        final error = responseJson['message'] ?? 'OTP verification failed';
        CustomSnackbar.show(
          title: 'Error',
          message: error,
          isError: true,
        );
        return false; // OTP verification failed
      }
    } catch (e) {
      print('========================');
      print(e);
      isLoading.value = false; // Set loading state to false
      CustomSnackbar.show(
        title: 'Error',
        message: 'Something went wrong. Please try again later.',
        isError: true,
      );
      return false; // Handle any errors
    }
  }

  void signUp() async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Validate input fields
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Please fill in all fields',
        isError: true,
      );
      return;
    }

    if (password != confirmPassword) {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Passwords do not match',
        isError: true,
      );
      return;
    }
    isLoading.value = true;
    // Get the user's current location
    final location = await getCurrentLocation();
    if (location == null) {
      return; // Stop the sign-up process if location is not available
    }

    // Prepare the request body
    final body = {
      'username': username,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
      'isDonor': isDonor.value,
      'latitude': location['latitude'],
      'longitude': location['longitude'],
    };

    try {
      // Set loading state to true
      // Send the POST request
      final response = await httpHelper.post('/auth/register', body);
      final responseJson = jsonDecode(response.body);
      isLoading.value = false; // Set loading state to false
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseJson['success'] == true) {
        SharedPreferencesHelper.saveString(
            'token', responseJson['data']['token']);
        tempSignupData = body;
        // Handle success
        // CustomSnackbar.show(
        //   title: 'Success',
        //   message: 'Account created successfully',
        //   isError: false,
        // );
        Get.toNamed('/verify_otp'); // Navigate to the login screen
      } else {
        final error = responseJson['message'];
        print('========================');
        print(error);
        CustomSnackbar.show(
          title: 'Error',
          message: error.isNotEmpty ? error : 'Failed to create account',
          isError: true,
        );
      }
    } catch (e) {
      // Handle exception
      CustomSnackbar.show(
        title: 'Error',
        message: 'Something went wrong. Please try again later.',
        isError: true,
      );
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is removed
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
