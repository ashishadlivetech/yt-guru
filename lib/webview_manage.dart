// import 'package:flutter/material.dart';
// import 'package:project1/googlelogin_webview.dart';
// import 'package:project1/video_webview.dart';

// class WebViewPage extends StatefulWidget {
//   final String videoUrl;
//   final int videoId;
//   final int points;
//   final int timer;

//   const WebViewPage({
//     super.key,
//     required this.videoUrl,
//     required this.videoId,
//     this.points = 0,
//     this.timer = 10, // Default 10 seconds
//   });

//   @override
//   _WebViewPageState createState() => _WebViewPageState();
// }

// class _WebViewPageState extends State<WebViewPage> {
//   bool isLoggedIn = false;

//   void _handleLoginSuccess() {
//     setState(() => isLoggedIn = true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: isLoggedIn
//             ? YouTubeWebView(
//                 videoUrl: widget.videoUrl,
//                 points: widget.points,
//                 timer: widget.timer,
//               )
//             : GoogleLoginWebView(onLoginSuccess: _handleLoginSuccess),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:project1/controllers/mobile_controler.dart';
import 'package:project1/google/login_api.dart';
import 'package:project1/video_webview.dart';
import 'package:get/get.dart';
import 'package:project1/youtube_screen.dart';

class WebViewPage extends StatefulWidget {
  final String videoUrl;
  final int id;
  final int points;
  final int timer;
  final String videoId;
  final String accessToken;
  final String fromScreen;

  const WebViewPage({
    super.key,
    required this.videoUrl,
    required this.id,
    this.points = 0,
    this.timer = 10,
    required this.videoId,
    required this.accessToken,
    required this.fromScreen,
    // Default 10 seconds
  });

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final AuthController authController =
      Get.find(); // Get the AuthController instance
  String?
      accessToken; // To store the access token retrieved from the controller

  @override
  void initState() {
    super.initState();
    _retrieveAccessToken(); // Retrieve the access token from secure storage
  }

  // Function to retrieve the access token from secure storage
  void _retrieveAccessToken() async {
    accessToken = await authController
        .getAccessToken(); // Get the token from AuthController
    setState(() {}); // Trigger a rebuild to use the token
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: accessToken != null
            ? YouTubePlayerScreen(
              videoUrl: widget.videoUrl,
                points: widget.points,
                seconds: widget.timer,
                videoId: widget.videoId,
                accessToken: accessToken, // Pass the access token here
                fromScreen: widget.fromScreen,
              )
            : Center(
                child:
                    CircularProgressIndicator()), // Show loading until token is retrieved
      ),
    );
  }
}
