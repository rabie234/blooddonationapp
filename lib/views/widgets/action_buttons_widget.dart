import 'package:blood_donation_app/utils/global_colors.dart';
import 'package:blood_donation_app/views/widgets/custom_button.dart';
import 'package:blood_donation_app/views/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blood_donation_app/controllers/home_controller.dart';

class ActionButtonsWidget extends StatelessWidget {
  final HomeController homeController =
      Get.put<HomeController>(HomeController());

  final List<Map<String, dynamic>> actions = [
    {
      'color': GlobalColors.primaryColor,
      'icon': Icons.volunteer_activism,
      'label': Text(
        'request'.tr,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: GlobalColors.textColor,
        ),
        textAlign: TextAlign.center,
      ),
      'onTap': (BuildContext context, HomeController controller) {
        _showRequestBottomSheet(context, controller, isEmergency: false);
      },
    },
    {
      'color': Colors.green,
      'icon': Icons.share,
      'label': Obx(() {
        return HomeController.isCopied.value
            ? Text(
                'link_copied'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              )
            : Text(
                'invite'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: GlobalColors.textColor,
                ),
                textAlign: TextAlign.center,
              ); // Hide the message when isCopied is false
      }),
      'onTap': (BuildContext context, HomeController controller) {
        HomeController.copyInviteLink(context);
      },
    },
    {
      'color': GlobalColors.primaryColor,
      'icon': Icons.warning,
      'label': Text(
        'emergency_request'.tr,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: GlobalColors.textColor,
        ),
        textAlign: TextAlign.center,
      ),
      'onTap': (BuildContext context, HomeController controller) {
        _showRequestBottomSheet(context, controller, isEmergency: true);
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((action) {
          return GestureDetector(
            onTap: () => action['onTap'](context, homeController),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: action['color'].withOpacity(0.1),
                  child: Icon(
                    action['icon'],
                    color: action['color'],
                    size: 30,
                  ),
                ),
                SizedBox(height: 8),
                action['label']
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  static void _showRequestBottomSheet(
      BuildContext context, HomeController controller,
      {required bool isEmergency}) {
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String? selectedBloodType;

    showModalBottomSheet(
      backgroundColor: GlobalColors.secondaryColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEmergency ? 'emergency_request'.tr : 'request'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: GlobalColors.primaryColor,
                  ),
                ),
                SizedBox(height: 16),
                CustomInputField(
                  hintText: 'quantity'.tr,
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
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
                  value: selectedBloodType,
                  items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                      .map((bloodType) {
                    return DropdownMenuItem(
                      value: bloodType,
                      child: Text(bloodType),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedBloodType = value;
                  },
                ),
                // DropdownButtonFormField<String>(
                //   value: selectedBloodType,
                //   items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                //       .map((bloodType) {
                //     return DropdownMenuItem(
                //       value: bloodType,
                //       child: Text(bloodType),
                //     );
                //   }).toList(),
                //   onChanged: (value) {
                //     selectedBloodType = value;
                //   },
                //   decoration: InputDecoration(
                //     labelText: 'Blood Type',
                //     labelStyle: TextStyle(color: GlobalColors.textColor),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: GlobalColors.primaryColor),
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                // ),
                SizedBox(height: 16),
                CustomInputField(
                  hintText: 'description'.tr,
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the bottom sheet
                      },
                      child: Text(
                        'cancel'.tr,
                        style: TextStyle(color: GlobalColors.buttonColor),
                      ),
                    ),
                    CustomButton(
                      onPressed: () async {
                        // Delegate the logic to the HomeController
                        await controller.addRequest(context, {
                          "type": isEmergency ? "emergency" : "normal",
                          "quantity": quantityController.text,
                          "blood_type": selectedBloodType,
                          "description": descriptionController.text,
                        });
                        Navigator.of(context).pop(); // Close the bottom sheet
                      },
                      text: 'save'.tr,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
