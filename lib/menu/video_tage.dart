import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/api_services/youtubetools/video_tagservice.dart';
import 'package:project1/theme_controller.dart';

class VideoTagPage extends StatefulWidget {
  @override
  _VideoTagPageState createState() => _VideoTagPageState();
}

class _VideoTagPageState extends State<VideoTagPage> {
  final ThemeController themeController = Get.find();
  final TextEditingController urlController = TextEditingController();
  List<String>? videoTags;

  Future<void> fetchTags() async {
    String url = urlController.text;
    if (url.isNotEmpty) {
      try {
        debugPrint("Fetching tags for URL: $url");

        List<String>? tags = await VideoTagService.createTag(url);

        debugPrint("Received tags: $tags");

        setState(() {
          videoTags = tags ?? []; // Ensures it never assigns null
        });
      } catch (e, stackTrace) {
        debugPrint("Error in fetchTags: $e");
        debugPrint("Stack Trace: $stackTrace");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Video Tags'),
        backgroundColor:
            themeController.isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: themeController.isDarkMode ? Colors.white : Colors.black,
        ),
        titleTextStyle: TextStyle(
          color: themeController.isDarkMode ? Colors.white : Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: themeController.isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructions
              Row(
                children: [
                  Icon(Icons.info_outline,
                      color: themeController.isDarkMode
                          ? Colors.grey
                          : Colors.black,
                      size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'How to get channel link: Open your channel on YT -> About -> Link under more information -> Copy link',
                      style: TextStyle(
                        color: themeController.isDarkMode
                            ? Colors.grey
                            : Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Text Field + Button Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode
                            ? Colors.grey.shade900
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: urlController,
                        style: TextStyle(
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: "Video Link address (URL)",
                          labelStyle: TextStyle(
                            color: themeController.isDarkMode
                                ? Colors.white70
                                : Colors.black54,
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
                    onPressed: fetchTags,
                    child: const Text("Add"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Show description texts before fetching tags, replace with tags after API response
              if (videoTags == null) ...[
                Text(
                  'This tool allows you to see the tags used in the videos you select.',
                  style: TextStyle(
                    color: themeController.isDarkMode
                        ? Colors.white70
                        : Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Video tags are used to search for videos and improve your search results (SEO).',
                  style: TextStyle(
                    color: themeController.isDarkMode
                        ? Colors.white70
                        : Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ] else if (videoTags!.isNotEmpty) ...[
                Text(
                  'Created Tags:',
                  style: TextStyle(
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: videoTags!.map((tag) {
                    return Chip(
                      label: Text(tag, style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.grey,
                    );
                  }).toList(),
                ),
              ] else ...[
                Text(
                  "No tags found.",
                  style: TextStyle(
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontSize: 14),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
