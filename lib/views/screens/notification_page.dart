import 'package:blood_donation_app/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'notifications_title'.tr,
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
        if (notificationController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (notificationController.notifications.isEmpty) {
          return Center(
            child: Text(
              'no_notifications'.tr,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: notificationController.notifications.length,
          itemBuilder: (context, index) {
            final notification = notificationController.notifications[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                onTap: () {
                  print(notification);
                  Get.toNamed(
                    '/details',
                    arguments: {
                      'id': notification['id'],
                      'isDonator': false,
                    },
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  child: Icon(
                    Icons.notifications,
                    color: Colors.red,
                  ),
                ),
                title: Text(
                  notification['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification['message'] ?? ''),
                    SizedBox(height: 5),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
