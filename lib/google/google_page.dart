
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project1/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_services/google/GoogleLoginAPIService.dart'
    show Googleloginapiservice;
import '../controllers/mobile_controler.dart';
import 'login_api.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount? _user;
  bool _isLoading = false;
  String _message = '';
  final AuthController authController = Get.find();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email', // Request email scope to get the user's email
      'https://www.googleapis.com/auth/plus.login', // Optional: to get more profile info
      'https://www.googleapis.com/auth/youtube.readonly'
    ],
  );

  Future googleSignIn() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final GoogleSignInAuthentication googleAuth = await user.authentication;

        setState(() {
          _user = user;
        });

        // Print the tokens for debugging
        debugPrint('✅ ID Token: ${googleAuth.idToken}');
        debugPrint('✅ Access Token: ${googleAuth.accessToken}');

        // Check if ID Token is null
        if (googleAuth.idToken == null) {
          log('ID Token is null');
        }
      }
    } catch (exception) {
      log('Google Sign-In Error: $exception');
    }
  }

  Future googleSignOut() async {
    try {
      await _googleSignIn.signOut();
      log('Sign Out Success');
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sign Out Success')));
      }
    } catch (exception) {
      log(exception.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sign Out Failed')));
      }
    }
  }

  Future<String> sendLoginService() async {
    setState(() {
      _isLoading = true;
    });

    String responseMessage =
        await Googleloginapiservice().sendGmailLogin(_user!.email);

    setState(() {
      _message = responseMessage;
      _isLoading = false;
    });

    if (responseMessage == 'Login Success') {
      authController.setEmail(_user!.email); // Save the email in GetStorage

      try {
        // Get the authentication object and access token
        final GoogleSignInAuthentication googleAuth =
            await _user!.authentication;
        if (googleAuth.accessToken != null) {
          await authController.setAccessToken(googleAuth.accessToken!);
        } else {
          print('Access Token is null');
        }

        // Debugging: Print the stored email and access token after saving
        String storedEmail = authController.box.read('email') ?? '';
        String? savedToken = await authController.getAccessToken();
        print('Stored Email: $storedEmail');
        print('Saved Access Token: $savedToken');
      } catch (e) {
        print('Error getting authentication: $e');
      }
    }

    return responseMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(seconds: 2),
              child: Image.asset(
                'assets/logo.png',
                width: 300,
                height: 400,
              ),
            ),
          ),
          if (_user == null) ...[
            ElevatedButton(
              onPressed: googleSignIn,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                backgroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/google.png',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                initialValue: _user!.email,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
          const SizedBox(height: 60),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'By continuing, you agree to YtGuru’s Terms of Use and Privacy Policy.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black45, fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
          if (_user != null) ...[
            GestureDetector(
              onTap: () async {
                try {
                  final result = await sendLoginService();
                  if (result == "Login Success") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login Failed')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
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
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
