// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:io';

// class GoogleLoginWebView extends StatefulWidget {
//   final VoidCallback onLoginSuccess;

//   const GoogleLoginWebView({super.key, required this.onLoginSuccess});

//   @override
//   _GoogleLoginWebViewState createState() => _GoogleLoginWebViewState();
// }

// class _GoogleLoginWebViewState extends State<GoogleLoginWebView> {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     clientId: Platform.isAndroid
//         ? '596525479150-bi6meg941uio75ourtse3612tv671gau.apps.googleusercontent.com' // Android Client ID
//         : null, // iOS uses GoogleService-Info.plist
//     scopes: ['email', 'profile'],
//   );

//   late final WebViewController _webViewController;
//   bool _isLoading = true;
//   String? _authUrl;
//   GoogleSignInAccount? _currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _webViewController = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (url) {
//             print("WebView page started: $url");
//           },
//           onPageFinished: (url) {
//             print("WebView page finished: $url");
//             if (url.contains("success")) {
//               print("Login successful via WebView");
//               widget.onLoginSuccess();
//               if (mounted) Navigator.pop(context);
//             } else if (url.contains("error")) {
//               print("Login error in WebView");
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Login failed")),
//               );
//               setState(() => _isLoading = false);
//             }
//           },
//           onWebResourceError: (error) {
//             print("WebView error: ${error.description}");
//             setState(() => _isLoading = false);
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("WebView failed: ${error.description}")),
//             );
//           },
//         ),
//       );

//     _startLoginProcess();
//   }

//   Future<void> _startLoginProcess() async {
//     try {
//       // Step 1: Attempt native Google Sign-In
//       print("Attempting native Google Sign-In...");
//       final GoogleSignInAccount? googleUser =
//           await _googleSignIn.signInSilently().catchError((e) {
//         print("Silent sign-in failed: $e");
//         return null;
//       });

//       final user = googleUser ?? await _googleSignIn.signIn();
//       if (user == null) {
//         print("Sign-in cancelled by user");
//         setState(() => _isLoading = false);
//         return;
//       }

//       final GoogleSignInAuthentication googleAuth = await user.authentication;
//       final idToken = googleAuth.idToken;
//       print("ID Token received: $idToken");

//       setState(() => _currentUser = user);

//       // Step 2: Use token with backend (optional WebView step)
//       // If your backend requires WebView authentication, configure this URL
//       const backendAuthUrl =
//           "https://your-backend.com/auth/google?token="; // Replace with your backend URL
//       _authUrl = "$backendAuthUrl$idToken";

//       if (_authUrl != null) {
//         print("Loading WebView with URL: $_authUrl");
//         await _webViewController.loadRequest(Uri.parse(_authUrl!));
//       } else {
//         // If no WebView is needed, call success directly
//         print("No WebView required, login successful");
//         widget.onLoginSuccess();
//         if (mounted) Navigator.pop(context);
//       }
//     } catch (e) {
//       print("Login error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Login failed: $e")),
//       );
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Google Login")),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _authUrl != null
//               ? WebViewWidget(controller: _webViewController)
//               : Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       if (_currentUser != null)
//                         Text("Logged in as: ${_currentUser!.displayName}"),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () {
//                           widget.onLoginSuccess();
//                           Navigator.pop(context);
//                         },
//                         child: const Text("Continue"),
//                       ),
//                     ],
//                   ),
//                 ),
//     );
//   }
// }
