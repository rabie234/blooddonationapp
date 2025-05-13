import 'dart:convert';
import 'package:blood_donation_app/models/user.dart';
import 'package:blood_donation_app/utils/http_helper.dart';
import 'package:blood_donation_app/utils/shared_preferences_helper.dart';
import 'package:blood_donation_app/views/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';

class UserController extends GetxController {
  var user = Rxn<User>(); // Observable for the User object
  final HttpHelper httpHelper = HttpHelper(); // Instance of HttpHelper

  // TextEditingControllers for editable fields
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController bloodTypeController;
  late TextEditingController phoneController;
  late TextEditingController countryController;
  late TextEditingController genderController;
  late TextEditingController birthdayController;

  // Switch states
  var isDonator = false.obs;
  var isNameVisible = true.obs;
  var isMapVisible = false.obs;
  var birthday = ''.obs;
  var allNotifications = false.obs;

  void initializeDataProfile() {
    // Initialize controllers with default empty values
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    bloodTypeController = TextEditingController();
    phoneController = TextEditingController();
    countryController = TextEditingController();
    genderController = TextEditingController();
    birthdayController = TextEditingController();

    // If user data is available, populate the controllers
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    if (user.value != null) {
      firstNameController.text = user.value?.firstName ?? '';
      lastNameController.text = user.value?.lastName ?? '';
      bloodTypeController.text = user.value?.bloodType ?? '';
      phoneController.text = user.value?.telephone ?? '';
      countryController.text =
          "${user.value?.country ?? ''}, ${user.value?.zone ?? ''}";
      genderController.text = user.value?.gender ?? '';
      birthdayController.text = user.value?.birthday ?? '';
      birthday.value = user.value?.birthday ?? '';

      // Initialize switch states
      isDonator.value = user.value?.isDonor ?? false;
      isNameVisible.value = user.value?.isNameVisible ?? false;
      isMapVisible.value = user.value?.isMapVisible ?? false;
      allNotifications.value = user.value?.allowAllNotification ?? false;
    }
    // });
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is removed
    firstNameController.dispose();
    lastNameController.dispose();
    bloodTypeController.dispose();
    phoneController.dispose();
    countryController.dispose();
    genderController.dispose();
    birthdayController.dispose();
    super.onClose();
  }

  void setUser(User userInfo) {
    user.value = userInfo;
  }

  void clearUser() {
    user.value = null;
    SharedPreferencesHelper.remove('token');
  }

  Future<bool> getUser() async {
    try {
      // Retrieve the token from SharedPreferences

      // Send a GET request to fetch user information
      final response = await httpHelper.get('/auth/checklogin');
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200 && responseJson['success'] == true) {
        // Parse the user data and update the user state

        final userData = User.fromJson(responseJson['data']['user']);
        OneSignal.login(userData.id);
        setUser(userData);
        if (responseJson['data']['user']['completed_info'] == false) {
          Get.offAllNamed('/home');
          Get.toNamed('/profile');
        } else {
          Get.offAllNamed('/home');
        }

        return true;
      } else {
        final error = responseJson['message'] ?? 'Failed to fetch user info';
        CustomSnackbar.show(
          title: 'Error',
          message: error,
          isError: true,
        );
        return false;
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Failed to fetch user info. Please try again later.',
        isError: true,
      );
      return false;
    }
  }

  Future<bool> updateUser() async {
    try {
      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        "blood_type": bloodTypeController.text,
        "gender": genderController.text,
        "birthday": birthday.value,
        "firstname": firstNameController.text,
        "lastname": lastNameController.text,
        "telephone": phoneController.text,
        "name_visible": isNameVisible.value,
        "is_donor": isDonator.value,
        "map_visible": isMapVisible.value,
        "notification_all": allNotifications.value
      };
      print(requestBody);
      // Send the PUT request to the API
      final response =
          await httpHelper.put('/account/account_information', requestBody);

      // Parse the response
      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200 && responseJson['success'] == true) {
        // Update the user object with the new data
        getUser();
        CustomSnackbar.show(
          title: 'Success',
          message: 'Your profile has been updated successfully!',
          isError: false,
        );
        return true;
      } else {
        // Handle API error
        final error = responseJson['message'] ?? 'Failed to update profile';
        CustomSnackbar.show(
          title: 'Error',
          message: error,
          isError: true,
        );
        return false;
      }
    } catch (e) {
      // Handle any exceptions
      print("Error updating user: $e");
      CustomSnackbar.show(
        title: 'Error',
        message:
            'An error occurred while updating the profile. Please try again later.',
        isError: true,
      );
      return false;
    }
  }
}
