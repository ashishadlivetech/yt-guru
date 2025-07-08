import 'package:flutter/material.dart';
import 'package:project1/GoogleSignInScreen.dart';
import 'package:project1/login_page.dart';
import 'package:project1/google/google_page.dart';

import 'google/google_play.dart' show LoginPlayPage;

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 🔹 Top Bar

          const Spacer(), // Pushes logo to center

          // 🔹 Logo
          Center(
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(seconds: 2), // Smooth fade-in effect
              child: Image.asset(
                'assets/logo.png',
                width: 300,
                height: 400,
              ),
            ),
          ),

          const Spacer(), // Pushes Terms text and button down

          // 🔹 Terms and Conditions Text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'By continuing, you agree to YtGuru’s Terms of Use and Privacy Policy.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black45, fontSize: 12),
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Gradient "Okay" Button
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPlayPage()),
              );
            },
            child: Container(
              width: 300,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF17887D), Color(0xFF50E4A4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Text(
                  "Okay",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
