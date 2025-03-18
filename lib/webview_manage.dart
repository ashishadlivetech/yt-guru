import 'package:flutter/material.dart';
import 'package:project1/googlelogin_webview.dart';
import 'package:project1/video_webview.dart';

class WebViewPage extends StatefulWidget {
  final String videoUrl;
  final int videoId;
  final int points;
  final int timer;

  const WebViewPage({
    super.key,
    required this.videoUrl,
    required this.videoId,
    this.points = 0,
    this.timer = 10, // Default 10 seconds
  });

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isLoggedIn = false;

  void _handleLoginSuccess() {
    setState(() => isLoggedIn = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoggedIn
            ? YouTubeWebView(
                videoUrl: widget.videoUrl,
                points: widget.points,
                timer: widget.timer,
              )
            : GoogleLoginWebView(onLoginSuccess: _handleLoginSuccess),
      ),
    );
  }
}
