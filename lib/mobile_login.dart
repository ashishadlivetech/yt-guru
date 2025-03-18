import 'package:flutter/material.dart';
import 'package:project1/api_services/login_otp/otp_services.dart';
import 'package:project1/otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileNumberPage extends StatefulWidget {
  const MobileNumberPage({super.key});

  @override
  _MobileNumberPageState createState() => _MobileNumberPageState();
}

class _MobileNumberPageState extends State<MobileNumberPage> {
  TextEditingController _mobileNumberController = TextEditingController();
  String _message = '';
  bool _isLoading = false; // To manage the loading state
  String _countryCode = '+91'; // Default country code

  final List<Map<String, String>> countryCodes = [
    {"code": "+1", "name": "US"},
    {"code": "+44", "name": "UK"},
    {"code": "+91", "name": "IN"},
    {"code": "+61", "name": "AU"},
    {"code": "+81", "name": "JP"},
    {"code": "+49", "name": "DE"},
    {"code": "+33", "name": "FR"},
  ];

  // Call sendOTP method from OtpService
  Future<void> sendOTP() async {
    setState(() {
      _isLoading = true;
    });

    String responseMessage =
        await OtpService().sendOTP(_mobileNumberController.text);
    setState(() {
      _message = responseMessage;
      _isLoading = false;
    });

    // If OTP is sent successfully, move to OTP page for verification
    if (responseMessage == 'OTP sent successfully') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('mobile_number', _mobileNumberController.text);

      // Navigate to OTP Page
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OTPPage(mobileNumber: _mobileNumberController.text)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), // Uniform padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Include the TopBar

            const SizedBox(height: 90), // Add some space

            // "My number is" text
            const Padding(
              padding: EdgeInsets.only(left: 8.0), // Shift text a bit to right
              child: Text(
                'My number is',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Country code and phone number input with an underlined style
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Colors.grey,
                      width: 1.5), // Single bottom underline
                ),
              ),
              child: Row(
                children: [
                  // Country Code Dropdown
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _countryCode,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      dropdownColor: Colors.white, // Background color
                      onChanged: (String? newValue) {
                        setState(() {
                          _countryCode = newValue!;
                        });
                      },
                      items: countryCodes.map<DropdownMenuItem<String>>(
                          (Map<String, String> item) {
                        return DropdownMenuItem<String>(
                          value: item['code']!,
                          child: Text('${item['code']} (${item['name']})',
                              style: const TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                    ),
                  ),

                  // Vertical separator line (optional)
                  Container(
                    width: 1,
                    height: 25,
                    color: Colors.grey,
                  ),

                  // Mobile Number Input
                  Expanded(
                    child: TextField(
                      controller: _mobileNumberController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(color: Colors.black45),
                        border: InputBorder.none, // No extra box
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Center the continue button
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : sendOTP,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                  ),
                  backgroundColor:
                      const Color(0xFF17887D), // Green button background
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      )
                    : const Text(
                        'CONTINUE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // Display OTP message
            Center(
              child: Text(
                _message,
                style: TextStyle(
                  color: _message == 'OTP sent successfully'
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
