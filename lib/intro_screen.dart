import 'package:flutter/material.dart';
import 'package:project1/dot_indicator.dart';
import 'package:project1/intro_page.dart';
import 'package:project1/terms.dart';
import 'package:project1/google/google_page.dart';

import 'google/google_play.dart' show LoginPlayPage;

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController =
      PageController(); // Controls the page view
  int _currentIndex = 0; // Keeps track of the current slide index

  // List of data for each intro slide
  final List<Map<String, String>> introData = [
    {
      "image": "assets/1.png",
      "title": "Shake the phone",
      "description": "Shake the phone every 3 hours and earn points"
    },
    {
      "image": "assets/2.png",
      "title": "Make your work easier",
      "description":
          "Make your work easier with artificial intelligence-supported tools"
    },
    {
      "image": "assets/3n.png",
      "title": "Manage your campaign",
      "description": "See and manage the details of the campaigns you created"
    },
    {
      "image": "assets/4.png",
      "title": "Create a campaign",
      "description":
          "Create a campaign for your channel with the points you collect"
    },
    {
      "image": "assets/5.png",
      "title": "Earn points",
      "description":
          "Collect points by watching videos, subscribing, or liking videos"
    },
    {
      "image": "assets/6.png",
      "title": "Improve your channel",
      "description":
          "By using this application, get interaction by making your channel and videos reach more people"
    },
  ];

  // Function to move to the next slide when Skip button is pressed
  void _onSkip() {
    if (_currentIndex < introData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPlayPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: introData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });

                if (index == introData.length - 1) {
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPlayPage()),
                    );
                  });
                }
              },
              itemBuilder: (context, index) => IntroPage(
                image: introData[index]["image"]!,
                title: introData[index]["title"]!,
                description: introData[index]["description"]!,
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: _onSkip,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: DotIndicator(
                currentIndex: _currentIndex,
                totalDots: introData.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
