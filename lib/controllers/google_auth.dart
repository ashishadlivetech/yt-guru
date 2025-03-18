import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project1/controllers/mobile_controler.dart';

class GoogleAuthService {
  final String apiUrl = "https://indianradio.in/yt-social-api/v1";
  final AuthController authController =
      Get.find<AuthController>(); // Get instance of AuthController

  /// Fetch the authentication URL from the API with stored mobile number
  Future<String?> fetchAuthUrl() async {
    String mobileNumber =
        authController.mobileNumber.value; // Get stored mobile number

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "method": "google_auth",
          "mobile_number": mobileNumber, // Send mobile number
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['data']; // Return the Google Auth URL
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception("Failed to fetch auth URL: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching auth URL: $e");
      return null;
    }
  }
}
