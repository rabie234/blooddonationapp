import 'package:blood_donation_app/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:blood_donation_app/models/donator.dart';

class MapSearch extends StatelessWidget {
  final List<Donator> donators;

  const MapSearch({
    Key? key,
    required this.donators,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return donators.isEmpty
        ? Center(
            child: Text("No data in this location try search another one !"))
        : FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(donators[0].latitude,
                  donators[0].longitude), // Default center of the map
              minZoom: 10.0, // Default zoom level
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: donators.map((donator) {
                  return Marker(
                    width: 50.0,
                    height: 50.0,
                    point: LatLng(
                      double.parse(donator.latitude.toString()), // Latitude
                      double.parse(donator.longitude.toString()), // Longitude
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Handle marker tap
                        Get.toNamed('/details', arguments: {
                          'donator': donator,
                          'isDonator': true,
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40.0, // Larger size for better visibility
                          ),
                          Positioned(
                            bottom: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                donator.bloodType,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
  }
}
