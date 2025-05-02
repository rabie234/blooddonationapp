import 'package:blood_donation_app/controllers/user_controller.dart';
import 'package:blood_donation_app/utils/global_colors.dart';
import 'package:blood_donation_app/views/widgets/custom_button.dart';
import 'package:blood_donation_app/views/widgets/custom_field.dart';
import 'package:blood_donation_app/views/widgets/custom_snackbar.dart';
import 'package:blood_donation_app/views/widgets/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      userController.birthday.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isInitialized = false;
    if (isInitialized == false) {
      userController.initializeDataProfile();
      isInitialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'edit_profile'.tr,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back(); // Navigate back to the previous screen
          },
        ),
      ),
      body: Obx(() {
        final user = userController.user.value;

        if (user == null) {
          return Center(
            child: Text(
              'No user data available.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: GlobalColors.primaryColor.withOpacity(0.1),
                    child: Text(
                      user.username[0]
                          .toUpperCase(), // First letter of username
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: GlobalColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    user.username,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Divider(
                  color: GlobalColors.lightGray,
                ),

                // ElevatedButton(
                //   onPressed: () async {
                //     final prefs = await SharedPreferences.getInstance();

                //     if (Get.locale?.languageCode == 'en') {
                //       Get.updateLocale(const Locale('ar'));
                //       await prefs.setString('lang', 'ar');
                //     } else {
                //       Get.updateLocale(const Locale('en'));
                //       await prefs.setString('lang', 'en');
                //     }
                //   },
                //   child: Text('Change Language'.tr),
                // ),

                GestureDetector(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();

                    if (Get.locale?.languageCode == 'en') {
                      Get.updateLocale(const Locale('ar'));
                      await prefs.setString('lang', 'ar');
                    } else {
                      Get.updateLocale(const Locale('en'));
                      await prefs.setString('lang', 'en');
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: GlobalColors.lightGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'change_language'.tr,
                          style: TextStyle(
                              fontSize: 16, color: GlobalColors.textColor),
                        ),
                        Icon(Icons.language, color: GlobalColors.primaryColor),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),
                // Editable fields
                Row(
                  children: [
                    Expanded(
                      child: CustomInputField(
                        hintText: 'first_name'.tr,
                        controller: userController.firstNameController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: CustomInputField(
                        hintText: 'last_name'.tr,
                        controller: userController.lastNameController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                CustomInputField(
                  hintText: 'phone_number'.tr,
                  controller: userController.phoneController,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: GlobalColors.accentColor),
                    focusColor: GlobalColors.lightGray,
                    labelText: 'blood_type'.tr,
                    filled: true,
                    fillColor: GlobalColors.lightGray,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: GlobalColors.primaryColor)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  value: userController.bloodTypeController.text.isNotEmpty
                      ? userController.bloodTypeController.text
                      : null,
                  items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                      .map((bloodType) => DropdownMenuItem(
                            value: bloodType,
                            child: Text(bloodType),
                          ))
                      .toList(),
                  onChanged: (value) {
                    userController.bloodTypeController.text = value ?? '';
                  },
                ),
                SizedBox(height: 15),
                CustomInputField(
                  readOnly: true,
                  hintText: 'country'.tr,
                  controller: userController.countryController,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: GlobalColors.accentColor),
                    focusColor: GlobalColors.lightGray,
                    labelText: 'gender'.tr,
                    filled: true,
                    fillColor: GlobalColors.lightGray,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: GlobalColors.primaryColor)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  value: userController.genderController.text.isNotEmpty
                      ? userController.genderController.text
                      : null,
                  items: ['male', 'female'] // Use raw keys
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child:
                                Text(gender.tr), // Translate only in the view
                          ))
                      .toList(),
                  onChanged: (value) {
                    userController.genderController.text = value ?? '';
                  },
                ),
                SizedBox(height: 15),
                Obx(() => GestureDetector(
                      onTap: () async {
                        _selectDate(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: GlobalColors.lightGray,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userController.birthday.value.isNotEmpty
                                  ? userController.birthday.value
                                  : 'select_birthday'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: userController.birthday.value.isNotEmpty
                                    ? GlobalColors.textColor
                                    : GlobalColors.textColor.withOpacity(0.6),
                              ),
                            ),
                            Icon(Icons.calendar_today,
                                color: GlobalColors.primaryColor),
                          ],
                        ),
                      ),
                    )),
                SizedBox(height: 15),
                Text(
                  'setting'.tr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: GlobalColors.lightGray,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSwitch(
                      title: 'donator'.tr,
                      warningDescription: true,
                      description: 'donator_switch'.tr,
                      icon: Icons.info,
                      value: userController.isDonator.value,
                      onChanged: (value) {
                        userController.isDonator.value = value;
                      },
                    ),
                    SizedBox(height: 15),
                    CustomSwitch(
                      title: 'show_name'.tr,
                      description: 'show_name_desc'.tr,
                      icon: Icons.person,
                      value: userController.isNameVisible.value,
                      onChanged: (value) {
                        userController.isNameVisible.value = value;
                      },
                    ),
                    SizedBox(height: 15),
                    CustomSwitch(
                      title: 'map'.tr,
                      description: 'map_desc'.tr,
                      icon: Icons.map,
                      value: userController.isMapVisible.value,
                      onChanged: (value) {
                        userController.isMapVisible.value = value;
                      },
                    ),
                    SizedBox(height: 15),
                    CustomSwitch(
                      title: 'notification'.tr,
                      description: 'notification_desc'.tr,
                      icon: FontAwesomeIcons.bell,
                      value: userController.allNotifications.value,
                      onChanged: (value) {
                        userController.allNotifications.value = value;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: GlobalColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'save'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      // Show a loading indicator
                      Get.dialog(
                        Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );
                      // Call the updateUser method
                      bool success = await userController.updateUser();
                      Get.back(); // close the loading
                      if (success) {
                        CustomSnackbar.show(
                            title: 'Success', message: "Succesfuly updated");
                      } else {
                        CustomSnackbar.show(
                            title: 'Error',
                            message: 'Failed To Update User',
                            isError: true);
                      }

                      // // Show feedback to the user
                      // if (success) {
                      //   Get.snackbar(
                      //     'Success',
                      //     'Profile updated successfully!',
                      //     snackPosition: SnackPosition.BOTTOM,
                      //     backgroundColor: Colors.green,
                      //     colorText: Colors.white,
                      //   );
                      // } else {
                      //   Get.snackbar(
                      //     'Error',
                      //     'Failed to update profile. Please try again.',
                      //     snackPosition: SnackPosition.BOTTOM,
                      //     backgroundColor: Colors.red,
                      //     colorText: Colors.white,
                      //   );
                      // }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
