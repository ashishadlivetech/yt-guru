import 'package:flutter/material.dart';

class ButtonStyles {
  static BoxDecoration gradientButton = BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xFF17887D), Color(0xFF50E4A4)], // Gradient colors
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(30), // Fully rounded corners
  );
}
