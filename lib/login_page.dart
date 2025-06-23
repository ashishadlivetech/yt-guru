// import 'package:flutter/material.dart';
// // Import the reusable TopBar
// import 'package:project1/button_styles.dart'; // Import Button Styles
// import 'mobile_login.dart';
// // Ensure correct import for SignUpPage

// class Login extends StatelessWidget {
//   const Login({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           // 🔹 Black rectangle at the top

//           const SizedBox(height: 30), // Space between top bar and logo

//           // 🔹 Logo (Positioned Below Black Rectangle)
//           Image.asset('assets/logo.png', width: 300, height: 200),

//           const SizedBox(height: 95), // Space below logo

//           // 🔹 Terms & Conditions Text
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 30),
//             child: Text(
//               "By clicking Log In, you agree with our Terms. Learn how we process your data in our Privacy Policy and Cookies Policy.",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.black, fontSize: 13),
//             ),
//           ),

//           const SizedBox(height: 30), // Space between buttons

//           // 🔹 Mobile Login Button (Navigates to MobileLogin Screen)
//           _buildGradientButton("assets/call.png", "LOGIN WITH PHONE", () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => MobileNumberPage()),
//             );
//           }),
//           // Space before sign-up option
//         ],
//       ),
//     );
//   }

//   // 🔹 Reusable Gradient Button Widget (Uses `ButtonStyles`)
//   Widget _buildGradientButton(
//       String iconPath, String text, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 270, // Set fixed width for buttons
//         height: 42, // Match the design dimensions
//         decoration: ButtonStyles.gradientButton, // Apply the gradient style
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(iconPath, width: 24, height: 24), // Icon
//             const SizedBox(width: 12), // Space between icon and text
//             Text(
//               text,
//               style: const TextStyle(
//                 color: Colors.white, // Light white text color
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
