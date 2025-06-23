import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project1/controllers/mobile_controler.dart';

class VideoTagService {
  static const String apiUrl = 'https://indianradio.in/yt-social-api/v1';

  static Future<List<String>?> createTag(String url) async {
    try {
      final AuthController authController = Get.find<AuthController>();
      //final String mobileNumber = authController.mobileNumber.value;
      final String email = authController.email.value;
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'method': 'create_tag',
          // 'mobile_number': mobileNumber,
          'email': email,
          'url': url,
        },
      );

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Raw Response Body: ${response.body}");

      // Check if response is valid JSON
      try {
        final decoded = jsonDecode(response.body);
        debugPrint("Decoded JSON: $decoded");

        if (decoded is Map<String, dynamic> &&
            decoded.containsKey('status') &&
            decoded['status'] == 'success' &&
            decoded.containsKey('data')) {
          List<String> tags = List<String>.from(decoded['data']);
          debugPrint("Extracted Tags: $tags");
          return tags;
        } else {
          debugPrint("Unexpected response format: $decoded");
        }
      } catch (e) {
        debugPrint("JSON Decode Error: $e");
      }
    } catch (e, stackTrace) {
      debugPrint("Exception in createTag: $e");
      debugPrint("Stack Trace: $stackTrace");
    }

    return null;
  }
}
