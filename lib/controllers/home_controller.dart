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
  var donors = <Donator>[].obs;
  static RxBool isCopied = false.obs;

  final HttpHelper httpHelper = HttpHelper();

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    try {
      isLoading.value = true;
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
    Clipboard.setData(ClipboardData(text: inviteLink));
    isCopied.value = true;
    Future.delayed(Duration(seconds: 3), () {
      isCopied.value = false;
    });
  }

  Future<bool> addRequest(
      BuildContext context, Map<String, dynamic> body) async {
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
                Navigator.of(context).pop(false);
              },
              child: Text(
                'cancel'.tr,
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
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

    if (confirmed == true) {
      try {
        Get.dialog(
          Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        final res =
            await httpHelper.post('/blood_data/add_blood_request', body);
        final resData = jsonDecode(res.body);

        Get.back();

        if (res.statusCode == 201 && resData['success'] == true) {
          CustomSnackbar.show(
            title: 'success'.tr,
            message: 'messageAddSuccess'.tr,
            isError: false,
          );
          return true;
        } else {
          CustomSnackbar.show(
            title: 'wrong'.tr,
            message: resData['message'] ?? 'messageAddFailed'.tr,
            isError: true,
          );
          return true;
        }
      } catch (e) {
        Get.back();
        CustomSnackbar.show(
          title: 'error'.tr,
          message: 'messageAddException'.tr,
          isError: true,
        );
        return false;
      }
    }

    return false;
  }
}
