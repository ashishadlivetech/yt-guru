import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  final String image; // Image path
  final String title; // Slide title
  final String description; // Slide description

  const IntroPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20), // Add padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image,
              height: 500,
              width: 500,
              fit: BoxFit.contain), // Adjusts image size

          SizedBox.shrink(), // Space between image and title

          // Title (Auto Resizes)
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 15), // Space between title and description

          // Description (Wraps and Adjusts)
          Flexible(
            child: Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.black45),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
