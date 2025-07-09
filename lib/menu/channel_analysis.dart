// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:project1/theme_controller.dart';

// class ChannelAnalysisPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final ThemeController themeController = Get.find();

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text('Channel analysis'),
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

class ChannelAnalysisPage extends StatefulWidget {
  @override
  _ChannelAnalysisPageState createState() => _ChannelAnalysisPageState();
}

class _ChannelAnalysisPageState extends State<ChannelAnalysisPage> {
  final TextEditingController _videoIdController = TextEditingController();
  final ThemeController themeController = Get.find();
  String? _description;
  bool _isLoading = false;

  Future<void> _fetchDescription() async {
    final videoId = _videoIdController.text.trim();
    if (videoId.isEmpty) return;

    setState(() {
      _isLoading = true;
      _description = null;
    });

    final videoData = await YouTubeService.fetchVideoProfile(videoId);
    setState(() {
      _isLoading = false;
      _description = videoData?.description ?? "No description found.";
    });
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
        title: const Text('Channel analysis'),
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
                    'Enter the YouTube Video ID to fetch its description.',
                    style: TextStyle(
                      color: isDark ? Colors.grey : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Input and Button
            Row(
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
                      controller: _videoIdController,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: "Enter YouTube Video ID",
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
                  onPressed: _fetchDescription,
                  child: const Text("Add"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_description != null)
              Text(
                "Description:",
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (_description != null) const SizedBox(height: 8),
            if (_description != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
