// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:project1/theme_controller.dart';

// class DownloadProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final ThemeController themeController = Get.find();

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text('Download profile'),
//         backgroundColor:
//             themeController.isDarkMode ? Colors.black : Colors.white,
//         elevation: 0,
//         iconTheme: IconThemeData(
//           color: themeController.isDarkMode ? Colors.white : Colors.black,
//         ),
//         titleTextStyle: TextStyle(
//           color: themeController.isDarkMode ? Colors.white : Colors.black,
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       backgroundColor: themeController.isDarkMode ? Colors.black : Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Instructions
//             Row(
//               children: [
//                 Icon(Icons.info_outline,
//                     color:
//                         themeController.isDarkMode ? Colors.grey : Colors.black,
//                     size: 16),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'How to get channel link: Open your channel on YT -> About -> Link under more information -> Copy link',
//                     style: TextStyle(
//                       color: themeController.isDarkMode
//                           ? Colors.grey
//                           : Colors.black,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             // Text Field for Channel Link
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: themeController.isDarkMode
//                           ? Colors.grey.shade900
//                           : Colors
//                               .grey.shade200, // Light background in light mode
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: TextField(
//                       style: TextStyle(
//                         color: themeController.isDarkMode
//                             ? Colors.white
//                             : Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: "Video Link address (URL)",
//                         labelStyle: TextStyle(
//                           color: themeController.isDarkMode
//                               ? Colors.white70
//                               : Colors.black54,
//                         ),
//                         border: InputBorder.none, // No border
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF17887D),
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 10),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   onPressed: () {
//                     // Add action here
//                   },
//                   child: const Text("Add"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/api_services/youtubetools/youtube_profileservice.dart';
import 'package:project1/theme_controller.dart';

class DownloadProfilePage extends StatefulWidget {
  @override
  _DownloadProfilePageState createState() => _DownloadProfilePageState();
}

class _DownloadProfilePageState extends State<DownloadProfilePage> {
  final TextEditingController _videoLinkController = TextEditingController();
  final ThemeController themeController = Get.find();
  String? _channelTitle;
  bool _isLoading = false;

  // Future<void> _fetchVideoData() async {
  //   final url = _videoLinkController.text.trim();
  //   if (url.isEmpty) return;

  //   final videoId = _extractVideoId(url);
  //   if (videoId == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Invalid YouTube URL")),
  //     );
  //     return;
  //   }

  //   setState(() => _isLoading = true);

  //   final videoData = await YouTubeService.fetchVideoProfile(videoId);
  //   setState(() {
  //     _isLoading = false;
  //     _channelTitle = videoData?.channelTitle;
  //   });
  // }
  Future<void> _fetchVideoData() async {
    final videoId = _videoLinkController.text.trim();
    if (videoId.isEmpty) return;

    setState(() => _isLoading = true);

    final videoData = await YouTubeService.fetchVideoProfile(videoId);
    setState(() {
      _isLoading = false;
      _channelTitle = videoData?.channelTitle;
    });
  }

  String? _extractVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    // Handle common formats
    if (uri.host.contains('youtube.com') && uri.queryParameters['v'] != null) {
      return uri.queryParameters['v'];
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeController.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Download profile'),
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
            Row(
              children: [
                Icon(Icons.info_outline,
                    color: isDark ? Colors.grey : Colors.black, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'How to get channel link: Open your channel on YT -> About -> Link under more information -> Copy link',
                    style: TextStyle(
                      color: isDark ? Colors.grey : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Text Field + Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _videoLinkController,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: "Video Link address (URL)",
                        labelStyle: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF17887D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _fetchVideoData,
                  child: const Text("Add"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_channelTitle != null)
              Text(
                "Channel Title: $_channelTitle",
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
