import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:project1/controllers/mobile_controler.dart';

class VideosServices {
  static const String baseUrl = 'https://indianradio.in/yt-social-api/v1';
  final AuthController authController = Get.find();

  Future<List<Map<String, dynamic>>> fetchVideos(String actionType) async {
    try {
      //String mobileNumber = authController.mobileNumber.value;
      final String email = authController.email.value;
      if (email.isEmpty) {
        throw Exception("Mobile number is missing");
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'method': 'get_videos',
          // 'mobile_number': mobileNumber
          'email': email
        },
      );

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success' && data['data'] is List) {
          List<Map<String, dynamic>> videos = (data['data'] as List)
              .where((video) => _isValidVideo(video, actionType))
              .map((video) => Map<String, dynamic>.from(video))
              .toList();

          return videos;
        } else {
          throw Exception("API Error: ${data['message']}");
        }
      } else {
        throw Exception(
            "Failed to fetch videos (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      print("API Error: $e");
      return [];
    }
  }

  /// Returns the correct key for the required action
  static String _getActionKey(String actionType) {
    switch (actionType) {
      case 'view':
        return 'view_num_view';
      case 'like':
        return 'like_num_view';
      case 'subscribe':
        return 'sub_num_view';
      default:
        throw Exception("Invalid action type: $actionType");
    }
  }

  /// Checks if a video is valid based on the action type
  static bool _isValidVideo(Map<String, dynamic> video, String actionType) {
    String actionKey = _getActionKey(actionType);
    String timeKey = actionKey.replaceAll("_num_view", "_time");

    return video.containsKey(actionKey) &&
        video.containsKey(timeKey) &&
        video[actionKey] != null &&
        video[timeKey] != null &&
        video[actionKey] != 0 &&
        video[timeKey] != 0;
  }
}
