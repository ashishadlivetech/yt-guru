import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:project1/controllers/mobile_controler.dart';

class AddcampService {
  final String _baseUrl = "https://indianradio.in/yt-social-api/v1";
  final AuthController authController = Get.find();

  Future<Map<String, dynamic>> addCampaign({
    required String videoUrl,
    int? viewNumView,
    int? viewTime,
    int? viewCost,
    int? subNumView,
    int? subTime,
    int? subCost,
    int? likeNumView,
    int? likeTime,
    int? likeCost,
  }) async {
    try {
      // String mobileNumber = authController.mobileNumber.value;
      String email = authController.email.value;

      if (email.isEmpty) {
        return {"success": false, "message": "email is missing"};
      }

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "method": "add_campaign",
          // "mobile_number": mobileNumber,
          "email": email,
          "url": videoUrl,
          if (viewNumView != null) "view_num_view": viewNumView.toString(),
          if (viewTime != null) "view_time": viewTime.toString(),
          if (viewCost != null) "view_cost": viewCost.toString(),
          if (subNumView != null) "sub_num_view": subNumView.toString(),
          if (subTime != null) "sub_time": subTime.toString(),
          if (subCost != null) "sub_cost": subCost.toString(),
          if (likeNumView != null) "like_num_view": likeNumView.toString(),
          if (likeTime != null) "like_time": likeTime.toString(),
          if (likeCost != null) "like_cost": likeCost.toString(),
        },
      );

      print("📥 API Response Status: ${response.statusCode}");
      print("📥 API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        String responseBody = response.body.trim();

        // Remove unwanted HTML if present
        int jsonStartIndex = responseBody.indexOf('{');
        if (jsonStartIndex != -1) {
          responseBody = responseBody.substring(jsonStartIndex);
        }

        try {
          var data = jsonDecode(responseBody);

          // ✅ Fix API message grammar
          if (data["message"]
              ?.toLowerCase()
              .contains("capmpaign has been created")) {
            data["message"] = "Campaign has been created successfully!";
          } else if (data["message"] == "Campaign has created") {
            data["message"] = "Campaign has been created successfully!";
          }

          return data;
        } catch (e) {
          print("❌ JSON Parse Error: $e");
          return {
            "success": false,
            "message": "Invalid server response, please try again later"
          };
        }
      } else {
        return {
          "success": false,
          "message": "Server error, please try again later"
        };
      }
    } catch (e) {
      print("❌ API Error: $e");
      return {
        "success": false,
        "message": "Network error, please check your connection"
      };
    }
  }
}
