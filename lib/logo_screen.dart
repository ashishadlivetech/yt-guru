import 'package:flutter/material.dart';
import 'package:project1/controllers/mobile_controler.dart';
import 'package:project1/homepage.dart';
import 'package:project1/intro_screen.dart';
import 'package:get/get.dart';

class Logoscreen extends StatefulWidget {
  const Logoscreen({super.key});

  @override
  State<Logoscreen> createState() => _LogoscreenState();
}

class _LogoscreenState extends State<Logoscreen> {
  final AuthController authController = Get.find(); // Get UserController

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2)); // ✅ Simulates loading time

    print(
        "Checking stored mobile number: ${authController.mobileNumber.value}"); // ✅ Debugging

    if (authController.mobileNumber.value.isNotEmpty) {
      print("✅ Mobile number found. Going to HomePage...");
      Get.offAll(() => Homepage());
    } else {
      print("❌ Mobile number missing. Going to LoginPage...");
      Get.offAll(() => IntroScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 🔹 Black Rectangle at the Top with Rounded Bottom Edge

          // 🔹 Centered Logo
          Center(
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(seconds: 2),
              child: Image.asset(
                'assets/logo.png', // Ensure this image exists
                width: 300, // Adjust size if needed
                height: 400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
