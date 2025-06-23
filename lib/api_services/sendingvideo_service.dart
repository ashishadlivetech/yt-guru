import 'package:http/http.dart' as http;

class VideoDetailSend {
  final String _baseUrl = "https://indianradio.in/yt-social-api/v1";

  /// **Report Video as Watched**
  Future<bool> reportVideoWatched({
    required String email,
    required String videoId,
    required String points,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          "method": "watched",
          //"mobile_number": mobileNumber
          'email': email,
          "video_id": videoId,
          "point": points,
        },
      );

      if (response.statusCode == 200) {
        print("Response: ${response.statusCode}, Body: ${response.body}");
        print("✅ Video watch reported successfully: ${response.body}");
        return true;
      } else {
        print("❌ Failed to report video watch: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Error reporting video watch: $e");
      return false;
    }
  }
}
