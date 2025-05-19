import 'package:blood_donation_app/controllers/notification_controller.dart';
import 'package:blood_donation_app/utils/global_colors.dart';
import 'package:blood_donation_app/views/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController =
        Get.put(NotificationController());
    notificationController.initArguments();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: GlobalColors.primaryColor,
        title: Text(
          notificationController.isDonator
              ? 'donator_details_title'.tr
              : 'request_details_title'.tr,
          style: TextStyle(color: GlobalColors.secondaryColor),
        ),
        iconTheme: IconThemeData(color: GlobalColors.secondaryColor),
      ),
      body: Obx(() {
        final donator = notificationController.donator.value;

        if (donator == null || notificationController.isLoadingOne.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (donator.isEmergency!)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: GlobalColors.warning.withOpacity(0.1),
                    border: Border.all(color: GlobalColors.warning),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: GlobalColors.warning),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'emergency_warning'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: GlobalColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: GlobalColors.primaryColor.withOpacity(0.1),
                  child: Text(
                    donator.name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: GlobalColors.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  donator.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: GlobalColors.textColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: GlobalColors.lightGray),
              const SizedBox(height: 16),

              // Blood Type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'blood_type'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: GlobalColors.primaryColor,
                    ),
                  ),
                  Stack(
                    children: [
                      Icon(FontAwesomeIcons.droplet,
                          size: 70, color: GlobalColors.lightGray),
                      Positioned(
                        top: 22,
                        left: donator.bloodType.length > 2 ? 20 : 25,
                        child: Text(
                          donator.bloodType,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: GlobalColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: GlobalColors.lightGray),
              const SizedBox(height: 16),

              // Name
              _buildInfoTile(
                icon: Icons.person_2_outlined,
                title: 'name'.tr,
                value: donator.name,
              ),

              // Phone
              _buildInfoTile(
                icon: Icons.phone,
                title: 'phone'.tr,
                value: donator.telephone,
                trailing: _buildPhoneMenu(donator.telephone),
              ),

              // Email
              _buildInfoTile(
                icon: Icons.email,
                title: 'email'.tr,
                value: donator.email,
              ),

              // Location
              _buildInfoTile(
                icon: Icons.pin_drop,
                title: 'location'.tr,
                value: "${donator.country}, ${donator.zone}",
                trailing: IconButton(
                  icon: Icon(Icons.map, color: GlobalColors.primaryColor),
                  onPressed: () async {
                    final Uri googleMapsUri = Uri(
                      scheme: 'https',
                      host: 'www.google.com',
                      path: '/maps/search/',
                      queryParameters: {
                        'api': '1',
                        'query': '${donator.latitude},${donator.longitude}',
                      },
                    );

                    // if (await canLaunchUrl(googleMapsUri)) {
                    try {
                      await launchUrl(googleMapsUri);
                    } catch (err) {
                      print(err);
                    }
                    // } else {
                    //   CustomSnackbar.show(
                    //     title: 'error'.tr,
                    //     message: 'error_map'.tr,
                    //     isError: true,
                    //   );
                    // }
                  },
                ),
              ),

              // Age
              _buildInfoTile(
                icon: Icons.person_2_sharp,
                title: 'age'.tr,
                value: donator.age.toString(),
              ),

              // Description
              if (donator.description != null &&
                  donator.description!.isNotEmpty)
                _buildInfoTile(
                  icon: Icons.info,
                  title: 'description'.tr,
                  value: donator.description!,
                ),
              if (donator.timeAgo != "")
                _buildInfoTile(
                  icon: Icons.timer,
                  value: '${donator.timeAgo!} ago',
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    String? title,
    required String value,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: GlobalColors.primaryColor),
      trailing: trailing,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              "$title:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: GlobalColors.textColor.withOpacity(0.6),
              ),
            ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: GlobalColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneMenu(String phone) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: GlobalColors.primaryColor),
      onSelected: (value) async {
        Uri? uri;

        if (value == 'call') {
          uri = Uri(scheme: 'tel', path: phone);
        } else if (value == 'whatsapp') {
          uri = Uri.parse("https://wa.me/${phone.replaceAll('+', '')}");
        }
        await launchUrl(uri!);
        // if (uri != null && await canLaunchUrl(uri)) {

        // } else {
        //   CustomSnackbar.show(
        //     title: 'error'.tr,
        //     message: value == 'call' ? 'error_call'.tr : 'error_whatsapp'.tr,
        //     isError: true,
        //   );
        // }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'call',
          child: Row(
            children: [
              Icon(Icons.call, color: GlobalColors.primaryColor),
              const SizedBox(width: 8),
              Text('call'.tr), // Replace with localized string if needed
            ],
          ),
        ),
        PopupMenuItem(
          value: 'whatsapp',
          child: Row(
            children: [
              Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
              const SizedBox(width: 8),
              Text('whatsapp'.tr),
            ],
          ),
        ),
      ],
    );
  }
}
