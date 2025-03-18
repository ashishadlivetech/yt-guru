import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width, // Full width of screen
      height: 110, // Fixed height
      decoration: const BoxDecoration(
        color: Colors.black, // Black background
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12), // Rounded bottom edges
          bottomRight: Radius.circular(12),
        ),
      ),
    );
  }
}
