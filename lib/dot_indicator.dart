import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int currentIndex; // The current slide index
  final int totalDots; // Total number of dots (slides)

  const DotIndicator({
    super.key,
    required this.currentIndex,
    required this.totalDots,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalDots, // Generates the correct number of dotsflutter devices
        (index) => AnimatedContainer(
          duration:
              Duration(milliseconds: 300), // Smooth transition between dots
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: currentIndex == index ? 12 : 7, // Highlight the active dot
          height: currentIndex == index ? 12 : 7,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? Colors.blue
                : Colors.grey[400], // Blue for active, grey for inactive
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
