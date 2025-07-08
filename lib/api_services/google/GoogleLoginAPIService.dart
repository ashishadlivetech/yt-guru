import 'package:http/http.dart' as http;
import 'dart:convert';

class Googleloginapiservice {
  // API base URL
  static const String _baseUrl = 'https://indianradio.in/yt-social-api/v1';

  // Method to send OTP
  Future<String> sendGmailLogin(String email) async {
    // Make a POST request to send the OTP
    var response = await http.post(
      Uri.parse(_baseUrl),
      body: {
        'method': 'login',
        'email': email,
      },
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return 'Login Success';
      } else {
        return 'Error when try to Login';
      }
    } else {
      return 'Error when try to Login';
    }
  }

}
