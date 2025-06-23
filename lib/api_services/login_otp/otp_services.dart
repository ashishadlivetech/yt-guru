// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class OtpService {
//   // API base URL
//   static const String _baseUrl = 'https://indianradio.in/yt-social-api/v1';

//   // Method to send OTP
//   Future<String> sendOTP(String mobileNumber) async {
//     // Make a POST request to send the OTP
//     var response = await http.post(
//       Uri.parse(_baseUrl),
//       body: {
//         'method': 'register',
//         'mobile_number': mobileNumber,
//       },
//     );

//     // Check if the request was successful
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       if (data['status'] == 'success') {
//         return 'OTP sent successfully';
//       } else {
//         return 'Error sending OTP';
//       }
//     } else {
//       return 'Failed to send OTP';
//     }
//   }

//   // Method to verify OTP
//   Future<String> verifyOTP(String mobileNumber, String otp) async {
//     // Make a POST request to verify the OTP
//     var response = await http.post(
//       Uri.parse(_baseUrl),
//       body: {
//         'method': 'verify_otp',
//         'mobile_number': mobileNumber,
//         'otp': otp,
//       },
//     );

//     // Check if the request was successful
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       if (data['status'] == 'success') {
//         return 'OTP verified successfully';
//       } else {
//         return 'Invalid OTP';
//       }
//     } else {
//       return 'Failed to verify OTP';
//     }
//   }
// }
