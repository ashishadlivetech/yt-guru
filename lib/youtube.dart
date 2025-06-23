import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:project1/api_services/sendingvideo_service.dart';
import 'package:project1/api_services/videos_services.dart';
import 'package:project1/controllers/mobile_controler.dart';
import 'package:project1/controllers/user_controller.dart';
import 'package:project1/theme_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:permission_handler/permission_handler.dart';


class YouTubePage extends StatefulWidget {
  const YouTubePage({super.key});

  @override
  _YouTubePageState createState() => _YouTubePageState();
}

class _YouTubePageState extends State<YouTubePage> {
  final ThemeController themeController = Get.find();
  final VideosServices videoService = VideosServices();
  final AuthController authController = Get.find();

  bool isAutoplayEnabled = false;
  List<Map<String, dynamic>> videos = [];
  int currentVideoIndex = 0;
  YoutubePlayerController? _youtubeController;
  int countdown = 0;
  Timer? _timer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    try {
      setState(() => isLoading = true);

      List<Map<String, dynamic>> fetchedVideos =
      await videoService.fetchVideos('view');

      List<Map<String, dynamic>> validVideos = fetchedVideos.where((video) {
        return video["url"] != null &&
            video["url"].isNotEmpty &&
            video["view_num_view"] != null &&
            video["view_num_view"].toString().trim().isNotEmpty &&
            video["view_num_view"] != "0" &&
            video["view_time"] != null &&
            video["view_time"].toString().trim().isNotEmpty &&
            video["view_time"] != "0" &&
            video["view_cost"] != null &&
            video["view_cost"].toString().trim().isNotEmpty &&
            video["view_cost"] != "0";
      }).toList();

      setState(() {
        videos = validVideos;
        isLoading = false;
      });

      if (videos.isNotEmpty) {
        _loadVideo();
      }
    } catch (e) {
      print("Error fetching view page videos: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadVideo() async {
    if (videos.isEmpty) return;

    String videoUrl = videos[currentVideoIndex]["url"];
    String? videoId = YoutubePlayer.convertUrlToId(videoUrl);

    if (videoId == null) return;

    // 🔸 Prompt permission before playing
    bool hasPermission = await _checkOverlayPermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Overlay permission is required to play videos."),
        ),
      );
      return;
    }

    // ✅ Proceed only if permission granted
    _youtubeController?.dispose();
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: isAutoplayEnabled,
        mute: false,
        loop: false,
      ),
    )..addListener(() {
      YoutubePlayerValue value = _youtubeController!.value;

      if (value.playerState == PlayerState.playing) {
        if (_timer == null || !_timer!.isActive) {
          _startCountdown();
        }
      } else if (value.playerState == PlayerState.paused ||
          value.playerState == PlayerState.ended) {
        _timer?.cancel();
      }
    });

    setState(() {
      countdown = int.tryParse(
        videos[currentVideoIndex]["view_time"].toString(),
      ) ??
          10;
    });
  }


  Future<bool> _checkOverlayPermission() async {
    if (await Permission.systemAlertWindow.isGranted) {
      return true;
    } else {
      final status = await Permission.systemAlertWindow.request();
      return status.isGranted;
    }
  }

  Future<String> _getPackageName() async {
    final info = await PackageInfo.fromPlatform();
    return info.packageName;
  }

  void _startCountdown() {
    _timer?.cancel();

    if (countdown > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdown > 0) {
          setState(() {
            countdown--;
          });
        } else {
          timer.cancel();
          _reportVideoAsWatched();
          _nextVideo();
        }
      });
    }
  }

  Future<void> _reportVideoAsWatched() async {
    if (videos.isEmpty) return;

    String email = authController.email.value;
    String videoId = videos[currentVideoIndex]["id"].toString();
    String points = videos[currentVideoIndex]["view_cost"].toString();

    VideoDetailSend videoDetailSend = VideoDetailSend();
    bool success = await videoDetailSend.reportVideoWatched(
      email: email,
      videoId: videoId,
      points: points,
    );

    if (success) {
      final userController = Get.find<UserController>();
      await userController.fetchUserData(forceRefresh: true);
      setState(() {});
    } else {
      print("❌ Failed to report video watch.");
    }
  }

  void _nextVideo() {
    if (videos.isNotEmpty) {
      _timer?.cancel();
      setState(() {
        currentVideoIndex = (currentVideoIndex + 1) % videos.length;
        _loadVideo();
      });
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: themeController.isDarkMode
          ? const Color(0xFF131225)
          : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Autoplay",
                  style: TextStyle(
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: 18,
                  ),
                ),
                Switch(
                  value: isAutoplayEnabled,
                  onChanged: (value) {
                    setState(() {
                      isAutoplayEnabled = value;
                      _loadVideo();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : (videos.isNotEmpty && _youtubeController != null
                  ? AspectRatio(
                aspectRatio: 9 / 7,
                child: YoutubePlayer(
                  controller: _youtubeController!,
                  showVideoProgressIndicator: true,
                ),
              )
                  : const Text("No videos available")),
            ),
            const SizedBox(height: 20),
            _buildVideoStats(),
            const SizedBox(height: 40),
            _buildNextVideoButton(),
          ],
        ),
      ),
    ));
  }

  Widget _buildVideoStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatBox(
          Icons.favorite,
          videos.isNotEmpty
              ? (videos[currentVideoIndex]["view_cost"] ?? "0").toString()
              : "0",
          "points",
        ),
        _buildStatBox(Icons.access_time, "$countdown", "seconds"),
      ],
    );
  }

  Widget _buildStatBox(IconData icon, String value, String label) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: themeController.isDarkMode ? Colors.white : Colors.black,
          ),
          child: Icon(
            icon,
            color:
            themeController.isDarkMode ? Colors.black : Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color:
                themeController.isDarkMode ? Colors.white : Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: themeController.isDarkMode
                    ? Colors.white70
                    : Colors.black45,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNextVideoButton() {
    return Center(
      child: SizedBox(
        width: 300,
        child: ElevatedButton(
          onPressed: _nextVideo,
          style: ElevatedButton.styleFrom(
            backgroundColor:
            themeController.isDarkMode ? Colors.white : Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            "See Another",
            style: TextStyle(
              fontSize: 18,
              color: themeController.isDarkMode
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
