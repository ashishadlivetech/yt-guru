import 'package:flutter/material.dart';
import 'package:project1/theme_controller.dart';
import 'package:get/get.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final ThemeController themeController = Get.find();

  PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          themeController.isDarkMode ? Color(0xFF131225) : Colors.white,
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
          style: TextStyle(
              color: themeController.isDarkMode ? Colors.white : Colors.black),
        ),
        backgroundColor:
            themeController.isDarkMode ? Color(0xFF131225) : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: themeController.isDarkMode
                  ? Colors.white
                  : Colors.black), // White back icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction
            Text(
              "This Privacy Policy describes how [Company Name] collects, uses, and protects the information you provide when using the UTU Attendance App.",
              style: TextStyle(
                  fontSize: 16,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black),
            ),
            SizedBox(height: 20),

            // Section 1: Information Collection
            _buildSectionTitle("1. Information Collection"),
            _buildBulletPoint(
                "1.1. Personal Information: When you register and use the UTU Attendance App, we may collect personal information such as your name, phone number, and profile details."),
            _buildBulletPoint(
                "1.2. Attendance Data: The app collects attendance data, including timestamps and location information through geofencing technology when you mark attendance."),
            _buildBulletPoint(
                "1.3. Leave Application: Information submitted when applying for leaves, including leave type, duration, and reason, is stored within the app."),

            SizedBox(height: 20),

            // Section 2: Use of Information
            _buildSectionTitle("2. Use of Information"),
            _buildBulletPoint(
                "2.1. Attendance Tracking: Attendance data, including location information, is used solely for the purpose of managing employee attendance records."),
            _buildBulletPoint(
                "2.2. Leave Management: Information provided during leave applications is used to process and manage employee leaves in accordance with company policies."),
            _buildBulletPoint(
                "2.3. Profile Information: Personal details in your profile are used for administrative purposes related to employment, such as contact information and job role."),

            SizedBox(height: 20),

            // Section 3: Data Security
            _buildSectionTitle("3. Data Security"),
            _buildBulletPoint(
                "3.1. We are committed to ensuring the security of your information. The UTU Attendance App employs industry-standard security measures to protect your data from unauthorized access, alteration, disclosure, or destruction."),
            _buildBulletPoint(
                "3.2. Access to your personal information is restricted to authorized personnel who have a need to access this data for the purposes outlined in this Privacy Policy."),

            SizedBox(height: 20),

            // Section 4: Information Sharing
            _buildSectionTitle("4. Information Sharing"),
            _buildBulletPoint(
                "4.1. We do not sell, trade, or otherwise transfer your personal information to outside parties unless required for legal compliance, law enforcement, or as necessary for the operation and maintenance of the app."),
            _buildBulletPoint(
                "4.2. In certain instances, we may share aggregated and anonymized data for analytical purposes or reporting."),

            SizedBox(height: 20),

            // Section 5: Third-Party Services
            _buildSectionTitle("5. Third-Party Services"),
            _buildBulletPoint(
                "5.1. The UTU Attendance App may contain links to third-party websites or services. We are not responsible for the privacy practices or content of these third-party sites."),

            SizedBox(height: 20),

            // Section 6: Consent
            _buildSectionTitle("6. Consent"),
            _buildBulletPoint(
                "6.1. By using the UTU Attendance App, you consent to the collection and use of your information as outlined in this Privacy Policy."),

            SizedBox(height: 20),

            // Section 7: Changes to Privacy Policy
            _buildSectionTitle("7. Changes to Privacy Policy"),
            _buildBulletPoint(
                "7.1. We reserve the right to update or modify this Privacy Policy at any time. Any changes will be posted on this page, and your continued use of the app after such modifications signifies your acceptance of the updated Privacy Policy."),

            SizedBox(height: 20),

            // Section 8: Contact Us
            _buildSectionTitle("8. Contact Us"),
            _buildBulletPoint(
                "8.1. If you have any questions or concerns regarding this Privacy Policy or the handling of your personal information, please contact us at [contact information]."),
          ],
        ),
      ),
    );
  }

  // Helper method for section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: themeController.isDarkMode ? Colors.white : Colors.black),
    );
  }

  // Helper method for bullet points
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8),
      child: Text(
        "• $text",
        style: TextStyle(
            fontSize: 16,
            color: themeController.isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }
}
