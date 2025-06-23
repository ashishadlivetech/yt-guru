import 'dart:convert';
import 'package:http/http.dart' as http;

// Campaign Model
class Campaign {
  final int id;
  final String url;
  final String? viewTime;
  final String? viewCost;
  final String? subTime;
  final String? subCost;
  final String? likeTime;
  final String? likeCost;

  Campaign({
    required this.id,
    required this.url,
    this.viewTime,
    this.viewCost,
    this.subTime,
    this.subCost,
    this.likeTime,
    this.likeCost,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'],
      url: json['url'],
      viewTime: json['view_time'] != '' ? json['view_time'] : null,
      viewCost: json['view_cost'] != '' ? json['view_cost'] : null,
      subTime: json['sub_time'] != '' ? json['sub_time'] : null,
      subCost: json['sub_cost'] != '' ? json['sub_cost'] : null,
      likeTime: json['like_time'] != '' ? json['like_time'] : null,
      likeCost: json['like_cost'] != '' ? json['like_cost'] : null,
    );
  }
}

// API Service
// class CampData {
//   Future<List<Campaign>> fetchCampaigns(String mobileNumber) async {
//     final url = Uri.parse('https://indianradio.in/yt-social-api/v1');

//     try {
//       final response = await http.post(
//         url,
//         body: {'method': 'get_campaign', 'email': 'email'},
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);

//         if (data['status'] == 'success') {
//           List<dynamic> campaignsJson = data['data'] ?? [];
//           // Ensure that campaignsJson contains valid data
//           return campaignsJson
//               .where((json) => json is Map<String, dynamic>)
//               .map((json) => Campaign.fromJson(json))
//               .toList();
//         }
//       }
//       print('Error: Response status code is ${response.statusCode}');
//       return [];
//     } catch (e) {
//       print('Error fetching campaigns: $e');
//       return [];
//     }
//   }
// }
class CampData {
  Future<List<Campaign>> fetchCampaigns(String email) async {
    final url = Uri.parse('https://indianradio.in/yt-social-api/v1');
    try {
      final response = await http.post(
        url,
        body: {'method': 'get_campaign', 'email': email},
      );

      // Debugging: Print the response body
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Check if 'status' is 'success'
        if (data['status'] == 'success') {
          List<dynamic> campaignsJson = data['data'] ?? [];
          return campaignsJson
              .where((json) => json is Map<String, dynamic>)
              .map((json) => Campaign.fromJson(json))
              .toList();
        } else {
          print("Error: API status is not 'success'");
        }
      }
      print('Error: Response status code is ${response.statusCode}');
      return [];
    } catch (e) {
      print('Error fetching campaigns: $e');
      return [];
    }
  }
}
