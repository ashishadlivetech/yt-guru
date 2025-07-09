import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  static const String _baseUrl = 'https://indianradio.in/yt-social-api/v1';

  static Future<VideoDataModel?> fetchVideoProfile(String videoId) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
      request.fields['method'] = 'download_profile';
      request.fields['videoId'] = videoId;

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return VideoDataModel.fromJson(json);
      } else {
        print('API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}

class VideoDataModel {
  final String title;
  final String description;
  final String channelId;
  final String thumbnailUrl;
  final String downloadCover;
  final String channelTitle;
  final String publishedAt;
  final List<String> tags;

  VideoDataModel({
    required this.title,
    required this.description,
    required this.channelId,
    required this.thumbnailUrl,
    required this.downloadCover,
    required this.channelTitle,
    required this.publishedAt,
    required this.tags,
  });

  factory VideoDataModel.fromJson(Map<String, dynamic> json) {
    final video = json['video'] ?? {};
    return VideoDataModel(
      title: video['title'] ?? json['title'] ?? '',
      description: video['description'] ?? json['description'] ?? '',
      channelId: video['channelId'] ?? json['channelId'] ?? '',
      thumbnailUrl:
          json['thumbnail'] ?? video['thumbnails']?['high']?['url'] ?? '',
      downloadCover: json['download_cover'] ?? '',
      channelTitle: video['channelTitle'] ?? '',
      publishedAt: video['publishedAt'] ?? '',
      tags: (video['tags'] ?? json['tags'] ?? []).cast<String>(),
    );
  }
}
