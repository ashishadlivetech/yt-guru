// import 'package:flutter/material.dart';
// import 'package:project1/controllers/mobile_controler.dart';
// import 'package:project1/homepage.dart';
// import 'package:project1/intro_screen.dart';
// import 'package:get/get.dart';

// class Logoscreen extends StatefulWidget {
//   const Logoscreen({super.key});

//   @override
//   State<Logoscreen> createState() => _LogoscreenState();
// }

// class _LogoscreenState extends State<Logoscreen> {
//   final AuthController authController = Get.find(); // Get UserController

//   @override
//   void initState() {
//     super.initState();
//     _navigateToNextScreen();
//   }

//   Future<void> _navigateToNextScreen() async {
//     await Future.delayed(Duration(seconds: 2)); // ✅ Simulates loading time

//     print(
//         "Checking stored mobile number: ${authController.mobileNumber.value}"); // ✅ Debugging

//     if (authController.email.value.isNotEmpty) {
//       print("✅ Mobile number found. Going to HomePage...");
//       Get.offAll(() => Homepage());
//     } else {
//       print("❌ Mobile number missing. Going to LoginPage...");
//       Get.offAll(() => IntroScreen());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           // 🔹 Black Rectangle at the Top with Rounded Bottom Edge

//           // 🔹 Centered Logo
//           Center(
//             child: AnimatedOpacity(
//               opacity: 1.0,
//               duration: const Duration(seconds: 2),
//               child: Image.asset(
//                 'assets/logo.png', // Ensure this image exists
//                 width: 300, // Adjust size if needed
//                 height: 400,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
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
  final AuthController authController = Get.find(); // Get the AuthController

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  // This method will check the stored email and navigate accordingly.
  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2)); // Simulates loading time

    // Debugging statement to check the stored email
    print("Checking stored email: ${authController.email.value}");

    // Check if the email is not empty (meaning the user is logged in)
    if (authController.email.value.isNotEmpty) {
      print(
          "✅ Email found: ${authController.email.value}. Going to HomePage...");
      // Navigate to HomePage if email exists
      Get.offAll(() => Homepage());
    } else {
      print("❌ Email missing. Going to IntroScreen...");
      // Navigate to IntroScreen (login page) if email is missing
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
          // 🔹 Centered Logo
          Center(
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(seconds: 2),
              child: Image.asset(
                'assets/logo.png', // Ensure this image exists in your assets folder
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
