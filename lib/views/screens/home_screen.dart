import 'package:blood_donation_app/controllers/home_controller.dart';
import 'package:blood_donation_app/controllers/notification_controller.dart';
import 'package:blood_donation_app/controllers/user_controller.dart';
import 'package:blood_donation_app/utils/global_colors.dart';
import 'package:blood_donation_app/views/widgets/action_buttons_widget.dart';
import 'package:blood_donation_app/views/widgets/custom_button.dart';
import 'package:blood_donation_app/views/widgets/data_slider_widget.dart';
import 'package:blood_donation_app/views/widgets/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final HomeController homeController = Get.put(HomeController());
  final NotificationController notificationController =
      Get.put(NotificationController()); // Initialize NotificationController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Obx(() {
          final user = userController.user.value;
          if (user == null) return SizedBox();

          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () => Get.toNamed('/profile'),
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(
                  user.username[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
        title: Obx(() {
          final user = userController.user.value;
          if (user == null) return SizedBox();

          return Text(
            user.username,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () => Get.toNamed('/search'),
          ),
          Obx(() {
            final hasNotifications =
                notificationController.notifications.isNotEmpty;
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.black),
                  onPressed: () => Get.toNamed('/notifications'),
                ),
                if (hasNotifications)
                  const Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.red,
                    ),
                  ),
              ],
            );
          }),
          IconButton(
              icon: const Icon(Icons.logout, color: Colors.black),
              onPressed: () {
                Get.defaultDialog(
                  title: 'confirm_logout'.tr,
                  content: Text('logout_message'.tr),
                  confirm: CustomButton(
                    onPressed: () {
                      userController.clearUser();
                      Get.offAllNamed('/login');
                    },
                    text: 'yes'.tr,
                  ),
                  cancel: CustomButton(
                    color: GlobalColors.backgroundColor,
                    textColor: GlobalColors.primaryColor,
                    onPressed: () {
                      Get.back();
                    },
                    text: 'no'.tr,
                  ),
                );

                // Show confirmation dialog
              })
        ],
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return Center(
            child: SpinKitChasingDots(
              color: GlobalColors.primaryColor,
              size: 40.0,
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageSlider(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/search');
                        // Handle location tap
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: GlobalColors.secondaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        constraints: BoxConstraints(
                            minWidth: 100), // Ensure minimum width
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // Ensure the Row takes only as much space as needed
                          children: [
                            Icon(Icons.location_on,
                                color: GlobalColors.primaryColor, size: 16),
                            SizedBox(width: 5),
                            Obx(() {
                              final country =
                                  userController.user.value?.country ??
                                      'Unknown';
                              final zone =
                                  userController.user.value?.zone ?? 'Unknown';
                              return Flexible(
                                child: Text(
                                  '$country, $zone',
                                  style: TextStyle(
                                    color: GlobalColors.accentColor,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Handle long text gracefully
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/profile');
                        // Handle location tap
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: GlobalColors.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // Ensure minimum width
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize
                              .min, // Ensure the Row takes only as much space as needed
                          children: [
                            Icon(Icons.bloodtype,
                                color: GlobalColors.backgroundColor, size: 16),
                            Obx(() {
                              final bloodType =
                                  userController.user.value?.bloodType ?? '';
                              return Row(
                                children: [
                                  SizedBox(width: 5),
                                  Text(
                                    bloodType,
                                    style: TextStyle(
                                      color: GlobalColors.backgroundColor,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Handle long text gracefully
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                ActionButtonsWidget(),
                SizedBox(height: 20),
                DataSliderWidget(
                  title: 'requesters'.tr,
                  data:
                      homeController.requesters, // Pass the list of requesters
                  onViewAll: () {
                    Get.toNamed(
                      '/search',
                      arguments: {
                        'filter': 'requester', // Pass the filter for requesters
                      },
                    );
                    // Handle location tap
                  },
                ),
                SizedBox(height: 20),
                DataSliderWidget(
                  title: 'donors'.tr,
                  data:
                      homeController.donors, // Pass the list of Donator objects
                  onViewAll: () {
                    Get.toNamed(
                      '/search',
                      arguments: {
                        'filter': 'donor', // Pass the filter for donators
                      },
                    );
                    // Handle "View All" for donators
                    print('View All Donators');
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}
