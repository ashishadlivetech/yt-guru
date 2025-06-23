// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class YouTubeWebView extends StatefulWidget {
//   final String videoUrl;
//   final int points;
//   final int timer;

//   const YouTubeWebView({
//     super.key,
//     required this.videoUrl,
//     this.points = 0,
//     this.timer = 10, // Default 10 seconds
//   });

//   @override
//   _YouTubeWebViewState createState() => _YouTubeWebViewState();
// }

// class _YouTubeWebViewState extends State<YouTubeWebView> {
//   late final WebViewController _webViewController;
//   int remainingTime = 0;
//   Timer? _timer;
//   bool videoStarted = false;

//   @override
//   void initState() {
//     super.initState();
//     remainingTime = widget.timer; // Set initial countdown value
//     _initializeWebView();
//   }

//   void _initializeWebView() {
//     String modifiedUrl =
//         "${widget.videoUrl}?autoplay=1&mute=1"; // Mute initially to enable autoplay

//     _webViewController = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(NavigationDelegate(
//         onPageFinished: (url) {
//           print("🎬 YouTube Video Loaded: $url");

//           _webViewController.runJavaScript("""
//         function ensureAutoplay() {
//           let video = document.querySelector('video');
//           if (video) {
//             video.muted = false; // Unmute the video
//             video.volume = 1.0; // Set volume to maximum
//             let playPromise = video.play();
//             if (playPromise !== undefined) {
//               playPromise.then(() => {
//                 console.log("✅ Video is playing with sound");
//               }).catch(() => {
//                 setTimeout(ensureAutoplay, 500); // Retry if blocked
//               });
//             }
//           }
//         }
//         ensureAutoplay(); // Trigger the autoplay function
//         """);

//           if (!videoStarted) {
//             _startTimer();
//           }
//         },
//       ))
//       ..loadRequest(Uri.parse(modifiedUrl));
//   }

//   void _startTimer() {
//     if (videoStarted) return;
//     videoStarted = true;

//     setState(() {
//       remainingTime = widget.timer;
//       print("⏳ Timer started with ${widget.timer} seconds");
//     });

//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (!mounted) {
//         timer.cancel();
//         return;
//       }

//       if (remainingTime > 0) {
//         setState(() {
//           remainingTime--;
//         });
//         print("⏲️ Countdown: $remainingTime seconds remaining");
//       } else {
//         timer.cancel();
//         print("✅ Video watched successfully.");
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: WebViewWidget(controller: _webViewController),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildIconWithText(
//                   Icons.favorite, widget.points.toString(), "Points"),
//               _buildIconWithText(
//                   Icons.access_time, remainingTime.toString(), "Seconds"),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildIconWithText(IconData icon, String number, String label) {
//     return Row(
//       children: [
//         Icon(icon, size: 24, color: Colors.black),
//         const SizedBox(width: 8),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               number,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Text(label,
//                 style: const TextStyle(fontSize: 14, color: Colors.black45)),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YouTubeWebView extends StatelessWidget {
  final String videoUrl;
  final int videoId;
  final int points;
  final int timer;
  final String? accessToken; // The access token passed from the WebViewPage

  const YouTubeWebView({
    super.key,
    required this.videoUrl,
    required this.videoId,
    required this.points,
    required this.timer,
    this.accessToken,
  });

  @override
  Widget build(BuildContext context) {
    // Create a WebViewController instance
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..loadRequest(Uri.parse(videoUrl)); // Load the initial URL

    return Scaffold(
      appBar: AppBar(title: const Text('YouTube')),
      body: WebViewWidget(
        controller: controller, // Use WebViewWidget with the controller
      ),
      // Handle page load events
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Inject the access token into the YouTube WebView once the page is loaded
          if (accessToken != null) {
            String jsCode = """
              // Store the access token in localStorage to authenticate the user
              window.localStorage.setItem('access_token', '$accessToken');
              // Optionally reload to ensure the token is applied
              location.reload();
            """;

            // Inject JavaScript code to authenticate the YouTube page
            controller.runJavaScript(jsCode);
          }
        },
        child: const Icon(Icons.code),
      ),
    );
  }
}
