import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/api_services/sendingvideo_service.dart';
import 'package:project1/api_services/videos_services.dart';
import 'package:project1/controllers/mobile_controler.dart';
import 'package:project1/controllers/user_controller.dart';
import 'package:project1/theme_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';

class YouTubePage extends StatefulWidget {
  const YouTubePage({super.key});

  @override
  _YouTubePageState createState() => _YouTubePageState();
}

class _YouTubePageState extends State<YouTubePage> {
  final ThemeController themeController = Get.find();
  final VideosServices videoService = VideosServices();
  final AuthController authController = Get.find(); // Get UserController

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
      setState(() => isLoading = true); // Show loading indicator

      List<Map<String, dynamic>> fetchedVideos =
          await videoService.fetchVideos('view');

      // 🔥 Strict Filtering - Only valid videos
      List<Map<String, dynamic>> validVideos = fetchedVideos.where((video) {
        return video["url"] != null &&
            video["url"].isNotEmpty &&
            video["view_num_view"] != null &&
            video["view_num_view"].toString().trim().isNotEmpty &&
            video["view_num_view"] != "0" && // 🔥 Exclude 0 values
            video["view_time"] != null &&
            video["view_time"].toString().trim().isNotEmpty &&
            video["view_time"] != "0" && // 🔥 Exclude 0 values
            video["view_cost"] != null &&
            video["view_cost"].toString().trim().isNotEmpty &&
            video["view_cost"] != "0"; // 🔥 Exclude 0 values
      }).toList();

      setState(() {
        videos = validVideos;
        isLoading = false;
      });

      // 🔥 Load the first video after fetching
      if (videos.isNotEmpty) {
        _loadVideo();
      }
    } catch (e) {
      print("Error fetching view page videos: $e");
      setState(() => isLoading = false);
    }
  }

  void _loadVideo() {
    if (videos.isNotEmpty) {
      String videoUrl = videos[currentVideoIndex]["url"];
      String? videoId = YoutubePlayer.convertUrlToId(videoUrl);

      if (videoId != null) {
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
                print("🎬 Video is playing, starting countdown...");
                _startCountdown();
              }
            } else if (value.playerState == PlayerState.paused ||
                value.playerState == PlayerState.ended) {
              print("⏸ Video paused or ended, stopping countdown...");
              _timer?.cancel();
            }
          });

        setState(() {
          countdown =
              int.tryParse(videos[currentVideoIndex]["view_time"].toString()) ??
                  10;
        });

        print("🔹 Countdown set to: $countdown seconds");
      }
    }
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
          print("⏳ Countdown finished!");

          // 🔥 Report the video as watched
          _reportVideoAsWatched();

          // 🔥 Load next video
          _nextVideo();
        }
      });
    }
  }

  Future<void> _reportVideoAsWatched() async {
    if (videos.isEmpty) return;

    String mobileNumber = authController.mobileNumber.value;
    String videoId =
        videos[currentVideoIndex]["id"].toString(); // Use id directly
    String points = videos[currentVideoIndex]["view_cost"]
        .toString(); // Use view_cost for points

    print("Sending request with:");
    print("Mobile: $mobileNumber, Video ID: $videoId, Points: $points");

    VideoDetailSend videoDetailSend = VideoDetailSend();
    bool success = await videoDetailSend.reportVideoWatched(
      mobileNumber: mobileNumber,
      videoId: videoId,
      points: points,
    );

    if (success) {
      print("✅ Successfully reported video as watched.");
      final userController = Get.find<UserController>(); // ✅ Get UserController
      await userController.fetchUserData(forceRefresh: true);
      setState(() {});
    } else {
      print("❌ Failed to report video watch.");
    }
  }

  void _nextVideo() {
    if (videos.isNotEmpty) {
      _timer?.cancel(); // Stop previous timer
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Autoplay",
                      style: TextStyle(
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontSize: 18),
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
                              aspectRatio: 9 / 7, // Shorts-like aspect ratio
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
            "points"),
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
          child: Icon(icon,
              color: themeController.isDarkMode ? Colors.black : Colors.white,
              size: 36),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: themeController.isDarkMode ? Colors.white : Colors.black,
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
                color:
                    themeController.isDarkMode ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }
}
