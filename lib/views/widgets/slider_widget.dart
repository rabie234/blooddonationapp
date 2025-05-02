import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageSlider extends StatelessWidget {
  ImageSlider({super.key});

  final List<Map<String, String>> sliderItems = [
    {
      "image":
          "https://regencyhealthcare.in/wp-content/uploads/2018/08/The-do%E2%80%99s-and-donts-of-donating-blood-1200x800.png",
      "title": "slider_title_1".tr
    },
    {
      "image":
          "https://www.clearyinsurance.com/wp-content/uploads/dontating-blood-1-1030x580.jpg",
      "title": "slider_title_2".tr
    },
    {
      "image":
          "https://news.va.gov/wp-content/uploads/sites/3/2023/01/Giving-blood-crop-Copy_vp1.jpg",
      "title": "slider_title_3".tr
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          height: 180,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9),
      items: sliderItems.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(item["image"]!, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      item["title"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
