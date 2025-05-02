import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> slides = [
    {
      'image': 'assets/images/hero_donate.png',
      'text': 'slide_1'.tr,
    },
    {
      'image': 'assets/images/save_lives.png',
      'text': 'slide_2'.tr,
    },
    {
      'image': 'assets/images/blood_donation.png',
      'text': 'slide_3'.tr,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Automate the slider
    Future.delayed(Duration.zero, () {
      _startAutoSlide();
    });
  }

  void _startAutoSlide() {
    Future.delayed(Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        int nextPage = (_currentIndex + 1) % slides.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentIndex = nextPage;
        });
        _startAutoSlide();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200, // Adjust the height of the slider
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: slides.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Image.asset(
                    slides[index]['image']!,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(
                    slides[index]['text']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            slides.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: _currentIndex == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index ? Colors.red : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
