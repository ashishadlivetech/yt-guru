import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project1/controllers/user_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

import 'controllers/mobile_controler.dart' show AuthController;


class YouTubePlayerScreen extends StatefulWidget {
  final String videoUrl;
  final int seconds;
  final int points;
  final String videoId;
  final String? accessToken; // The access token passed from the WebViewPage
  final String fromScreen;

  const YouTubePlayerScreen({
    super.key,
    required this.videoUrl,
    required this.seconds,
    required this.points,
    required this.videoId,
    this.accessToken,
    required this.fromScreen,
  });

  @override
  State<YouTubePlayerScreen> createState() => _YouTubeWebViewState();
}

class _YouTubeWebViewState extends State<YouTubePlayerScreen> {
  late WebViewController _controller;
  String? videoId;
  String? channelId;
  int remainingSeconds = 0;
  Timer? _timer;
  bool _isCountdownStarted = false;
  bool _countdownFinished = false;

  final AuthController authController =
  Get.find();

  final UserController userController =
  Get.find();

  @override
  void initState() {
    super.initState();
    videoId = _extractVideoId(widget.videoUrl);
    remainingSeconds = widget.seconds;

    if (videoId != null) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse("https://m.youtube.com/watch?v=$videoId"))
        ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (String url) {
            if (!_isCountdownStarted) {
              _isCountdownStarted = true;
              _startCountdown();
            }
          },
        ));

      fetchChannelIdFromVideo(videoId!, "AIzaSyCM0q7bhdRbjT7vfiogDyIyY5clyC_s058").then((id) {
        setState(() {
          channelId = id;
        });
      });
    }
  }


  Future<void> _launchChannel() async {
    if (channelId == null) return;

    final url = Uri.parse('https://www.youtube.com/channel/$channelId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open YouTube')),
      );
    }
  }

  Future<void> _likeVideo() async {
    if (videoId == null) return;

    final url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open YouTube')),
      );
    }
  }



  /* void loadChannelInfo() async {
    String videoUrl = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";
    String? videoId = _extractVideoId(videoUrl);


    if (videoId != null) {
      String? channelId = await fetchChannelIdFromVideo(videoId, apiKey);
      print("Channel ID: $channelId");

      if (channelId != null) {
            _buildHtml(videoId!,channelId);
        // Now use this channelId to inject into your HTML
      }
    }
  }
*/

  Future<String?> fetchChannelIdFromVideo(String videoId, String apiKey) async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/videos?part=snippet&id=$videoId&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        return data['items'][0]['snippet']['channelId'];
      }
    } else {
      print("Failed to fetch channelId: ${response.body}");
    }
    return null;
  }


  String? _extractVideoId(String url) {
    final shortRegex = RegExp(r"shorts/([a-zA-Z0-9_-]+)");
    final match = shortRegex.firstMatch(url);
    return match?.group(1);
  }



  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        timer.cancel();
        _onCountdownFinished();
      }
    });
  }

  void _onCountdownFinished() {
    setState(() {
      _countdownFinished = true; // Hide old layout, show new one
    });
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Done!"),
       // content: Text("You've earned ${widget.points} points!"),
        content: Text("You can now ${widget.fromScreen} to avail points"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

/*  Future<bool> isUserSubscribed(String accessToken, String channelId) async {
    final url = Uri.parse(
        'https://www.googleapis.com/youtube/v3/subscriptions?part=snippet&forChannelId=$channelId&mine=true'
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final isSubscribed= (data['items'] as List).isNotEmpty;
      if(isSubscribed)
        {

        }
      return (data['items'] as List).isNotEmpty;
    } else {
      print("Subscription check failed: ${response.body}");
      Navigator.pop(context);
      return false;
    }
  }*/


  Future<bool> isUserSubscribed(String accessToken, String channelId) async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/subscriptions?part=snippet&forChannelId=$channelId&mine=true',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final isSubscribed = (data['items'] as List).isNotEmpty;

      if (isSubscribed) {
        try {
          // ✅ Call your backend API after confirming subscription
          final String email = authController.email.value;
          final apiResponse = await http.post(
            Uri.parse('https://indianradio.in/yt-social-api/v1'),
            /*headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken', // or your auth header
            },*/

            body: {
              'method': 'credit_coin_by_event',
              // 'mobile_number': mobileNumber
              'email': email,
              'point_to_be_credit': widget.points.toString(),
              'action' : 'subscribe',
              'video_id': widget.videoId
            },

            /*body: jsonEncode({
              'channelId': channelId,
              // Include user ID or other context if needed
            }),*/
          );

          if (apiResponse.statusCode == 200) {
            // Optional: parse response or show success
            //int newPoints= (int.tryParse(userController.userPoints.value) ?? 0) + widget.points;
           // userController.updatePoints(newPoints);
            await userController.fetchUserData(
                forceRefresh: true);
            setState(() {});
            Navigator.pop(context,true);
            print("Backend API success: ${apiResponse.body}");
            return true;
          } else {
            print("Backend API failed: ${apiResponse.body}");
            return false;
          }
        } catch (e) {
          print("Error calling backend API: $e");
          return false;
        }
      } else {
        return false;
      }
    } else {
      print("YouTube subscription check failed: ${response.body}");
      return false;
    }
  }

  Future<bool> isVideoLiked(String accessToken, String videoId) async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/videos?myRating=like&part=id&maxResults=50',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final likedVideoIds = (data['items'] as List)
          .map((item) => item['id'] as String)
          .toList();
        bool isLiked= likedVideoIds.contains(videoId);
        if(isLiked)
          {
            try {
              // ✅ Call your backend API after confirming subscription
              final String email = authController.email.value;
              final apiResponse = await http.post(
                Uri.parse('https://indianradio.in/yt-social-api/v1'),
                /*headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken', // or your auth header
            },*/

                body: {
                  'method': 'credit_coin_by_event',
                  // 'mobile_number': mobileNumber
                  'email': email,
                  'point_to_be_credit': widget.points.toString(),
                  'action' : 'subscribe',
                  'video_id': widget.videoId
                },

                /*body: jsonEncode({
              'channelId': channelId,
              // Include user ID or other context if needed
            }),*/
              );

              if (apiResponse.statusCode == 200) {
                // Optional: parse response or show success
                //int newPoints= (int.tryParse(userController.userPoints.value) ?? 0) + widget.points;
                //userController.updatePoints(newPoints);

                await userController.fetchUserData(
                    forceRefresh: true);
                setState(() {});
                Navigator.pop(context,true);
                print("Backend API success: ${apiResponse.body}");
                return true;
              } else {
                print("Backend API failed: ${apiResponse.body}");
                return false;
              }
            } catch (e) {
              print("Error calling backend API: $e");
              return false;
            }
          } else {
          return false;
        }
    } else {
      print("Failed to fetch liked videos: ${response.body}");
      return false;
    }
  }




  Future<void> revokeAccessToken(String accessToken) async {
    final url = Uri.parse('https://oauth2.googleapis.com/revoke?token=$accessToken');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      print("✅ Token revoked successfully.");
    } else {
      print("❌ Failed to revoke token: ${response.body}");
    }
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildInfoBox(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (videoId == null) {
      return const Scaffold(
        body: Center(child: Text("Invalid YouTube Shorts URL")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Watch & Earn"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (remainingSeconds > 0)
                // Blocking all touches until countdown finishes
                  AbsorbPointer(
                    absorbing: true,
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
              ],
            ),
          ),
          if (channelId != null)
            Padding(
              padding: const EdgeInsets.all(10.0),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: _countdownFinished
                ? ElevatedButton.icon(
              onPressed: () async {
               // Navigator.pop(context,"subscribed"); // or navigate to another screen
                if (widget.accessToken != null && channelId != null) {
                  if(widget.fromScreen=="Subscribe")
                    {
                      bool isSubscribed = await isUserSubscribed(widget.accessToken!, channelId!);
                      if (isSubscribed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("✅ Subscribed! Moving to app...")),
                        );
                        // Navigate or do other logic
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("❌ You haven't subscribed yet.")),
                        );
                      }
                    }else{
                       bool isLiked = await isVideoLiked(widget.accessToken!, videoId!);
                    if (isLiked) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ Liked! Moving to app...")),
                      );
                      // Navigate or do other logic
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("❌ You haven't liked yet.")),
                      );
                    }

                  }

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Missing access token or channel ID.")),
                  );
                }
              },
              icon: const Icon(Icons.exit_to_app),
              label: const Text("Move to App"),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red),
                    Text("${widget.points} Points"),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.timer),
                    Text("$remainingSeconds Seconds"),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
