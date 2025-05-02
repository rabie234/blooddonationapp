import 'package:blood_donation_app/models/donator.dart';
import 'package:blood_donation_app/utils/http_helper.dart';
import 'package:get/get.dart';
import 'dart:convert';

class NotificationController extends GetxController {
  final HttpHelper httpHelper = HttpHelper();

  var notifications = <dynamic>[].obs;
  var isLoading = true.obs;
  var isLoadingOne = false.obs;

  var donator = Rxn<Donator>();
  bool isDonator = false;
  String? donatorId;

  @override
  void onInit() {
    super.onInit();

    fetchNotifications();
    // Extract and handle arguments
  }

  void initArguments() {
    final args = Get.arguments;

    if (args != null && args['donator'] != null) {
      donator.value = args['donator'];
      isDonator = args['isDonator'] ?? false;
    } else {
      donatorId = args['id'];
      fetchNotificationDetails(donatorId!);
    }
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;

      final response = await httpHelper.get('/account/notifications');
      final data = jsonDecode(response.body);
      final responseJson = data['data']['notifications'] ?? [];

      notifications.value = responseJson.map((item) {
        return {
          'id': item['_id'],
          'title': item['title'],
          'message': item['content'],
          'time': item['time'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      Get.snackbar(
        'Error',
        'An error occurred while fetching notifications',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNotificationDetails(String id) async {
    try {
      isLoadingOne.value = true;

      final response = await httpHelper.get(
        '/account/notification?notification_id=$id',
      );

      final data = jsonDecode(response.body);
      final responseJson = data['data'] ?? {};
      donator.value = Donator.fromJson(responseJson);
      // print(donator);
    } catch (e) {
      // print(e);
      // print('Error fetching notifications: $e');
      Get.snackbar(
        'Error',
        'An error occurred while fetching notification',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingOne.value = false;
    }
  }
}
