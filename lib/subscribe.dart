import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:get/get.dart';
import 'package:project1/api_services/videos_services.dart';
import 'package:project1/button_styles.dart';
import 'package:project1/theme_controller.dart';
import 'package:project1/webview_manage.dart'; // Import WebViewPage

class Subscribe extends StatefulWidget {
  const Subscribe({super.key});

  @override
  _SubscribeState createState() => _SubscribeState();
}

class _SubscribeState extends State<Subscribe> {
  bool isAutoplayEnabled = false;
  final ThemeController themeController = Get.find();
  final VideosServices videosServices = VideosServices();
  List<Map<String, dynamic>> videos = [];
  int currentIndex = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    try {
      setState(() => isLoading = true);

      List<Map<String, dynamic>> fetchedVideos =
          await videosServices.fetchVideos('subscribe');

      // Filtering out invalid videos
      List<Map<String, dynamic>> validVideos = fetchedVideos.where((video) {
        return video["url"] != null &&
            video["url"].isNotEmpty &&
            video["thum"] != null &&
            video["thum"].isNotEmpty &&
            video["title"] != null &&
            video["title"].isNotEmpty &&
            video["sub_num_view"] != null &&
            video["sub_num_view"].toString().isNotEmpty &&
            video["sub_time"] != null &&
            video["sub_time"].toString().isNotEmpty &&
            video["sub_cost"] != null &&
            video["sub_cost"].toString().isNotEmpty;
      }).toList();

      if (validVideos.isNotEmpty) {
        setState(() {
          videos = validVideos;
          currentIndex = 0;
        });
      } else {
        setState(() => videos = []);
      }
    } catch (e) {
      print("Error fetching subscribed videos: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _openWebView() async {
    if (videos.isNotEmpty && currentIndex < videos.length) {
      bool? isGranted = await FlutterOverlayWindow.isPermissionGranted();
      if (!isGranted) {
        await FlutterOverlayWindow.requestPermission();
      }

      await FlutterOverlayWindow.showOverlay(
        height: 600, // Adjust size based on need
        width: 350,
        alignment: OverlayAlignment.center,
        flag: OverlayFlag.defaultFlag,
        enableDrag: true,
        overlayTitle: "Watching Video",
        overlayContent: "Video is playing...",
      );

      // Open WebView page inside the overlay
      Get.to(() => WebViewPage(
            videoUrl: videos[currentIndex]['url'] ?? '',
            videoId: videos[currentIndex]['id'] is int
                ? videos[currentIndex]['id']
                : int.tryParse(videos[currentIndex]['id'].toString()) ?? 0,
            points: parseValue(videos[currentIndex]['sub_num_view']),
            timer: parseValue(videos[currentIndex]['sub_time']),
          ));
    }
  }

  void _loadNextVideo() {
    setState(() {
      if (currentIndex + 1 < videos.length) {
        currentIndex++;
      } else {
        _fetchVideos(); // Fetch more videos when you reach the end
      }
    });
  }

  int parseValue(dynamic value) {
    if (value == null || value == "") {
      return 0;
    } else if (value is String) {
      return int.tryParse(value) ?? 0;
    } else if (value is int) {
      return value;
    }
    return 0;
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
                          fontSize: 18),
                    ),
                    Switch(
                      value: isAutoplayEnabled,
                      onChanged: (value) {
                        setState(() {
                          isAutoplayEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (videos.isNotEmpty)
                  Column(
                    children: [
                      Image.network(
                        videos[currentIndex]
                            ['thum'], // Fetching the thumbnail from API
                        width: 200,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        videos[currentIndex]
                            ['title'], // Fetching the title from API
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  )
                else
                  Center(child: CircularProgressIndicator()),
                const SizedBox(height: 20),
                if (videos.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildIconWithText(
                          Icons.favorite,
                          parseValue(videos[currentIndex]['sub_num_view'])
                              .toString(),
                          "Points"),
                      _buildIconWithText(
                          Icons.access_time,
                          parseValue(videos[currentIndex]['sub_time'])
                              .toString(),
                          "Seconds"),
                    ],
                  )
                else
                  const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 20),
                _buildInfoText(),
                const SizedBox(height: 20),
                _buildActionButtons(),
              ],
            ),
          ),
        ));
  }

  Widget _buildIconWithText(IconData icon, String number, String label) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: themeController.isDarkMode ? Colors.white : Colors.black,
          ),
          child: Center(
            child: Icon(icon,
                color: themeController.isDarkMode ? Colors.black : Colors.white,
                size: 36),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: TextStyle(
                color: themeController.isDarkMode ? Colors.white : Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color:
                    themeController.isDarkMode ? Colors.white : Colors.black45,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info,
            color: themeController.isDarkMode ? Colors.white : Colors.black,
            size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "The account you use in this application must be the same account you use on YT.",
            style: TextStyle(
                color: themeController.isDarkMode ? Colors.white : Colors.black,
                fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildGradientButton("Subscribe", _openWebView),
            _buildGradientButton("See Another", _loadNextVideo),
          ],
        ),
      ],
    );
  }

  Widget _buildGradientButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 50,
        decoration: ButtonStyles.gradientButton,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
