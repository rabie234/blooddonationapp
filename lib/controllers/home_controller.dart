import 'dart:convert';
import 'package:blood_donation_app/views/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:blood_donation_app/utils/http_helper.dart';
import 'package:blood_donation_app/models/donator.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var requesters = <Donator>[].obs;
  var donors = <Donator>[].obs; // Use Donator type for donors
  static RxBool isCopied = false.obs;

  final HttpHelper httpHelper = HttpHelper(); // Instance of HttpHelper

  @override
  void onInit() {
    super.onInit();
    getData(); // Automatically fetch data when the controller is initialized
  }

  Future<void> getData() async {
    try {
      isLoading.value = true;

      // Make the API call to fetch nearest blood data
      final response = await httpHelper.get('/blood_data/nearest_blood_data');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        requesters.value = (responseData['data']['blood_requests'] ?? [])
            .map<Donator>((json) => Donator.fromJson(json))
            .toList();
        donors.value = (responseData['data']['donators'] ?? [])
            .map<Donator>((json) => Donator.fromJson(json))
            .toList();

        print('Donors: ${donors.length}');
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  static void copyInviteLink(BuildContext context) {
    const String inviteLink = 'https://bloodlife.org';

    // Copy the link to the clipboard
    Clipboard.setData(ClipboardData(text: inviteLink));

    // Set isCopied to true
    isCopied.value = true;

    // Revert isCopied to false after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      isCopied.value = false;
    });
  }

  Future<bool> addRequest(
      BuildContext context, Map<String, dynamic> body) async {
    // Show a confirmation dialog
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'add_request'.tr,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'add_request_confirmation'.tr,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'add_request_note'.tr,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: Text(
                'cancel'.tr,
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm
              },
              child: Text(
                'confirm'.tr,
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );

    // If the user confirmed, proceed with adding the request
    if (confirmed == true) {
      try {
        // Show a loading indicator
        Get.dialog(
          Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        // Create a new request

        final res =
            await httpHelper.post('/blood_data/add_blood_request', body);
        print(res);
        final resData = jsonDecode(res.body);
        if (res.statusCode == 200 && resData['success'] == true) {
          // Dismiss the loading indicator
          Get.back();

          CustomSnackbar.show(
            title: 'Success',
            message: 'The request has been added successfully.',
            isError: false,
          );
          return true;
        } else {
          Get.back();

          CustomSnackbar.show(
            title: 'Wrong',
            message: resData['message'],
            isError: true,
          );
          return true;
        }
      } catch (e) {
        // Handle any exceptions
        Get.back(); // Dismiss the loading indicator if an error occurs
        CustomSnackbar.show(
          title: 'Error',
          message:
              'An error occurred while adding the request. Please try again later.',
          isError: true,
        );
        return false;
      }
    }

    // If the user canceled, return false
    return false;
  }
}
