import 'dart:convert';
import 'package:blood_donation_app/controllers/user_controller.dart';
import 'package:blood_donation_app/utils/http_helper.dart';
import 'package:blood_donation_app/utils/shared_preferences_helper.dart';
import 'package:blood_donation_app/views/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class LoginController extends GetxController {
  late TextEditingController identifierController;
  late TextEditingController passwordController;
  bool success = false;
  var isLoading = false.obs; // Observable for loading state

  final HttpHelper httpHelper = HttpHelper(); // Instance of HttpHelper

  void login() async {
    String identifier = identifierController.text.trim();
    String password = passwordController.text.trim();

    // Validate input fields
    if (identifier.isEmpty || password.isEmpty) {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Please fill in all fields',
        isError: true,
      );
      return;
    }

    // Prepare the request body
    final body = {
      'identifier': identifier,
      'password': password,
    };

    try {
      isLoading.value = true; // Set loading state to true

      // Send the POST request
      final response = await httpHelper.post('/auth/login', body);
      final responseJson = jsonDecode(response.body);
      // Debugging line to check the response
      isLoading.value = false; // Set loading state to false

      if (response.statusCode == 200 && responseJson['success'] == true) {
        // Save the token to SharedPreferences
        await SharedPreferencesHelper.saveString(
            'token', responseJson['data']['accessToken']['token']);
        final userController = Get.find<UserController>();
        await userController.getUser();
      } else {
        // Handle error response
        final error = responseJson['message'] ?? 'Login failed';
        CustomSnackbar.show(
          title: 'Error',
          message: error,
          isError: true,
        );
      }
    } catch (e) {
      // Debugging line to check the error
      isLoading.value = false; // Set loading state to false
      // Handle exception
      CustomSnackbar.show(
        title: 'Error',
        message: 'Something went wrong. Please try again later.',
        isError: true,
      );
    }
  }

  Future<bool> socialLogin(String email, String userName, String provider,
      double longitude, double latitude, bool? isDonor) async {
    isLoading.value = true;
    // Prepare the request body
    final body = {
      'email': email,
      'name': userName,
      'provider': provider,
      'longitude': 0,
      'latitude': 0,
      if (isDonor != null) 'isDonor': isDonor,
    };

    try {
      // Set loading state to true

      // Send the POST request
      final response = await httpHelper.post('/auth/loginSocial', body);
      final responseJson = jsonDecode(response.body);
      // Debugging line to check the response
      isLoading.value = false; // Set loading state to false

      if (response.statusCode == 200 && responseJson['success'] == true) {
        // Save the token to SharedPreferences
        await SharedPreferencesHelper.saveString(
            'token', responseJson['data']['accessToken']['token']);
        final userController = Get.find<UserController>();
        await userController.getUser();
        success = true;
      } else {
        // Handle error response
        final error = responseJson['message'] ?? 'Login failed';
        CustomSnackbar.show(
          title: 'Error',
          message: error,
          isError: true,
        );
        success = false;
      }
    } catch (e) {
      success = false;
      // Debugging line to check the error
      isLoading.value = false; // Set loading state to false
      // Handle exception
      CustomSnackbar.show(
        title: 'Error',
        message: 'Something went wrong. Please try again later.',
        isError: true,
      );
    }
    return success;
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is removed

    super.onClose();
  }
}
