import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project1/controllers/mobile_controler.dart';
import 'package:get/get.dart';

class PointsAddservice {
  static const String _baseUrl = "https://indianradio.in/yt-social-api/v1";

  /// Method to credit coins
  static Future<void> creditCoins(int points) async {
    final AuthController authController =
        Get.find<AuthController>(); // Get instance of AuthController
    // final String mobileNumber =
    //     authController.mobileNumber.value; // Get stored mobile number
    final String email = authController.email.value;
    if (email.isEmpty) {
      print("❌ Error:email is empty");
      return;
    }

    final Uri url = Uri.parse(_baseUrl);
    final Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
    };
    final Map<String, String> body = {
      "method": "credit_coin",
      //"mobile_number": mobileNumber,
      'email': email,
      "point_to_be_credit": points.toString(),
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      print("🔄 Response Code: ${response.statusCode}");
      print("📩 Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          if (responseData['status'] == "success") {
            print("✅ Success: ${responseData['message']}");
          } else {
            print("⚠️ API Error: ${responseData['message']}");
          }
        } catch (e) {
          print("⚠️ Response is not valid JSON: ${response.body}");
        }
      } else {
        print("⚠️ Failed: ${response.body}");
      }
    } catch (e) {
      print("❌ Error: $e");
    }
  }
}
