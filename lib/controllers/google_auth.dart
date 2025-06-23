import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

class GoogleAuthService extends StatefulWidget {
  const GoogleAuthService({super.key});

  @override
  _GoogleAuthServiceState createState() => _GoogleAuthServiceState();
}

class _GoogleAuthServiceState extends State<GoogleAuthService> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: Platform.isAndroid
        ? '596525479150-bi6meg941uio75ourtse3612tv671gau.apps.googleusercontent.com' // Android Client ID
        : null, // iOS uses GoogleService-Info.plist
    scopes: ['email', 'profile'],
  );

  bool _isLoading = false;
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _checkSilentSignIn();
  }

  Future<void> _checkSilentSignIn() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        print("Silent sign-in succeeded: ${account.displayName}");
      }
    } catch (e) {
      print("Silent sign-in failed: $e");
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      print("Starting Google sign-in...");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Sign-in cancelled by user");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print("ID Token: ${googleAuth.idToken}");
      print("Access Token: ${googleAuth.accessToken}");

      setState(() => _currentUser = googleUser);

      // Navigate to home screen on success
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e, stackTrace) {
      print("Sign-in error: $e\nStackTrace: $stackTrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-in failed: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    try {
      await _googleSignIn.signOut();
      setState(() => _currentUser = null);
      print("User signed out");
    } catch (e) {
      print("Sign-out error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Authentication")),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_currentUser != null) ...[
                    Text("Hello, ${_currentUser!.displayName}"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signOut,
                      child: const Text("Sign Out"),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: _signInWithGoogle,
                      child: const Text("Sign in with Google"),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
