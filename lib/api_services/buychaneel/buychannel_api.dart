// import 'dart:convert';
// import 'dart:ffi';
// import 'package:http/http.dart' as http;

// class ChannelApiService {
//   static Future<List<ChannelModel>> fetchChannels() async {
//     final url = Uri.parse("https://indianradio.in/yt-social-api/v1");
//     final response = await http.post(url, body: {"method": "get_channels"});

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//       if (data["status"] == "success") {
//         // If the response is a single channel (not a list), wrap it
//         final channelData = data["data"];
//         return [ChannelModel.fromJson(channelData)];
//       } else {
//         throw Exception("Failed: ${data['message']}");
//       }
//     } else {
//       throw Exception("Failed to load channels");
//     }
//   }
// }

// class ChannelModel {
//   final int id;
//   final String title;
//   final String link;
//   final String img;
//   final String viewCount;
//   final int subCount;
//   final int likeCount;
//   final String category;
//   final bool monetized;
//   final String channelAge;
//   final String revenue;
//   final String description;

//   ChannelModel({
//     required this.id,
//     required this.title,
//     required this.link,
//     required this.img,
//     required this.viewCount,
//     required this.subCount,
//     required this.likeCount,
//     required this.category,
//     required this.monetized,
//     required this.channelAge,
//     required this.revenue,
//     required this.description,
//   });

//   factory ChannelModel.fromJson(Map<String, dynamic> json) {
//     return ChannelModel(
//       id: json['id'],
//       title: json['title'],
//       link: json['link'],
//       img: "https://indianradio.in/${json['img']}",
//       viewCount: json['view_count'],
//       subCount: json['sub_count'],
//       likeCount: json['like_count'],
//       category: json['category'],
//       monetized: json['monetized'],
//       channelAge: json['channel_age'],
//       revenue: json['revenue'],
//       description: json['description'],
//     );
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class ChannelApiService {
  static Future<List<ChannelModel>> fetchChannels() async {
    final url = Uri.parse("https://indianradio.in/yt-social-api/v1");
    final response = await http.post(url, body: {"method": "get_channels"});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        final channelData = data["data"];

        // Wrap in a list, assuming single-channel response for now
        return [ChannelModel.fromJson(channelData)];
      } else {
        throw Exception("Failed: ${data['message']}");
      }
    } else {
      throw Exception("Failed to load channels");
    }
  }
}

class ChannelModel {
  final int id;
  final String title;
  final String link;
  final String img;
  final int viewCount;
  final int subCount;
  final int likeCount;
  final String category;
  final String monetized;
  final String channelAge;
  final String revenue;
  final String description;

  ChannelModel({
    required this.id,
    required this.title,
    required this.link,
    required this.img,
    required this.viewCount,
    required this.subCount,
    required this.likeCount,
    required this.category,
    required this.monetized,
    required this.channelAge,
    required this.revenue,
    required this.description,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'],
      title: json['title'],
      link: json['link'],
      img: "https://indianradio.in/${json['img']}",
      viewCount: json['view_count'] is int
          ? json['view_count']
          : int.tryParse(json['view_count'].toString()) ?? 0,
      subCount: json['sub_count'] is int
          ? json['sub_count']
          : int.tryParse(json['sub_count'].toString()) ?? 0,
      likeCount: json['like_count'] is int
          ? json['like_count']
          : int.tryParse(json['like_count'].toString()) ?? 0,
      category: json['category'],
      monetized: json['monetized'],
      channelAge: json['channel_age'],
      revenue: json['revenue'].toString(),
      description: json['description'],
    );
  }
}
