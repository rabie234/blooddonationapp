import 'package:blood_donation_app/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:blood_donation_app/models/donator.dart';
import 'package:get/get.dart';

class DataSliderWidget extends StatelessWidget {
  final String title;
  final List<Donator> data;
  final VoidCallback onViewAll;

  DataSliderWidget({
    required this.title,
    required this.data,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & View All
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: Text(
                  'view_all'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // If no data
        if (data.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              children: [
                Icon(Icons.no_accounts_outlined,
                    color: GlobalColors.primaryColor, size: 40),
                Text(
                  'no_data_message'.trParams({'title': 'donators'}),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          // Horizontal slider
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final donator = data[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed('/details', arguments: {
                      'donator': donator,
                      'isDonator': title.tr != 'requesters'.tr,
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 150,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor:
                                    GlobalColors.primaryColor.withOpacity(0.1),
                                child: Text(
                                  donator.bloodType.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalColors.primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                donator.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_pin,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      ' ${donator.zone}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${'age'.tr}: ${donator.age}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  if (donator.timeAgo != "")
                                    Text(
                                      ' ${donator.timeAgo} ago',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (donator.isEmergency)
                        Positioned(
                          top: -2,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: GlobalColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.notification_important_outlined,
                              size: 18,
                              color: GlobalColors.warning,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
