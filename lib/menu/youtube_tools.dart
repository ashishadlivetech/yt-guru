import 'package:flutter/material.dart';
import 'package:project1/menu/channel_analysis.dart';
import 'package:project1/menu/create_desct.dart';
import 'package:project1/menu/create_tag.dart';
import 'package:project1/menu/create_title.dart';
import 'package:project1/menu/download_cover.dart';
import 'package:project1/menu/download_profile.dart';
import 'package:project1/menu/video_tage.dart';
import 'package:project1/menu/video_thumb.dart';
import 'package:project1/theme_controller.dart';
import 'package:get/get.dart';

class YouTubeToolsPage extends StatelessWidget {
  final ThemeController themeController = Get.find();

  final List<Map<String, dynamic>> tools = [
    {
      'title': 'Create Title',
      'image': 'assets/title.png',
      'color': Color(0xFFC4EAD5)
    },
    {
      'title': 'Create Description',
      'image': 'assets/description.png',
      'color': Color(0xFFD2E8F8)
    },
    {
      'title': 'Create Tag',
      'image': 'assets/tag.png',
      'color': Color(0xFFEFDDD2)
    },
    {
      'title': 'Video Tag',
      'image': 'assets/video_tag.png',
      'color': Color(0xFFE7DBF6)
    },
    {
      'title': 'Download Profile',
      'image': 'assets/profile.png',
      'color': Color(0xFFFCCCCC)
    },
    {
      'title': 'Download Cover',
      'image': 'assets/cover.png',
      'color': Color(0xFFF3E8C1)
    },
    {
      'title': 'Video Thumbnail',
      'image': 'assets/thumbnail.png',
      'color': Color(0xFFC4EAD5)
    },
    {
      'title': 'Channel Analysis',
      'image': 'assets/analysis.png',
      'color': Color(0xFFD2E8F8)
    },
  ];

  YouTubeToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode ? Colors.black : Colors.grey,
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 110,
            color: themeController.isDarkMode ? Colors.black : Colors.grey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: themeController.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        size: 30),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "YouTube Tools",
                    style: TextStyle(
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: themeController.isDarkMode
                    ? Color(0xFF131225)
                    : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.8,
                        ),
                        itemCount: tools.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              switch (tools[index]['title']) {
                                case 'Create Title':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreateTitlePage()));
                                  break;
                                case 'Create Description':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreateDescriptionPage()));
                                  break;
                                case 'Create Tag':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreateTagPage()));
                                  break;
                                case 'Video Tag':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VideoTagPage()));
                                  break;
                                case 'Download Profile':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DownloadProfilePage()));
                                  break;
                                case 'Download Cover':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DownloadCoverPage()));
                                  break;
                                case 'Video Thumbnail':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VideoThumbnailPage()));
                                  break;
                                case 'Channel Analysis':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChannelAnalysisPage()));
                                  break;
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: tools[index]['color'],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    tools[index]['image'],
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      tools[index]['title'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Create Thumbnail",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "Coming Soon",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Other Placeholder Pages (No changes needed)
