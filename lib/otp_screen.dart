import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/api_services/login_otp/otp_services.dart';
import 'package:project1/controllers/mobile_controler.dart';
import 'package:project1/homepage.dart'; // Navigate to the Homepage

class OTPPage extends StatefulWidget {
  final String mobileNumber;

  OTPPage({required this.mobileNumber});

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  TextEditingController _otpController1 = TextEditingController();
  TextEditingController _otpController2 = TextEditingController();
  TextEditingController _otpController3 = TextEditingController();
  TextEditingController _otpController4 = TextEditingController();
  String _message = '';

  // Focus nodes to manage focus between OTP fields
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();

  // Call verifyOTP method from OtpService
  Future<void> verifyOTP() async {
    String otp = _otpController1.text +
        _otpController2.text +
        _otpController3.text +
        _otpController4.text;
    String responseMessage =
        await OtpService().verifyOTP(widget.mobileNumber, otp);
    setState(() {
      _message = responseMessage;
    });

    // If OTP is verified successfully, update login status and navigate to homepage
    if (responseMessage == 'OTP verified successfully') {
      final AuthController authController = Get.find();
      authController
          .setMobileNumber(widget.mobileNumber); // ✅ Save Mobile Number

      Get.offAll(
          () => Homepage()); // ✅ Redirect to Homepage after storing number
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      body: Column(
        children: [
          // Top Bar (with black background, no padding on left and right, and rounded corners downward)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            height: 100, // Set the height for the black top bar
            width: double
                .infinity, // Make sure it stretches across the full screen
            child: const SizedBox(), // Empty container
          ),
          const SizedBox(height: 20), // Space between top bar and content

          // Main content inside the container
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white, // Background color inside the container
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Enter OTP text
                Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                // Row for four separate OTP input fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOTPField(
                        controller: _otpController1,
                        focusNode: null,
                        nextFocusNode: _focusNode2),
                    _buildOTPField(
                        controller: _otpController2,
                        focusNode: _focusNode2,
                        nextFocusNode: _focusNode3),
                    _buildOTPField(
                        controller: _otpController3,
                        focusNode: _focusNode3,
                        nextFocusNode: _focusNode4),
                    _buildOTPField(
                        controller: _otpController4,
                        focusNode: _focusNode4,
                        nextFocusNode: null),
                  ],
                ),
                const SizedBox(height: 20),

                // Verify OTP button
                ElevatedButton(
                  onPressed: verifyOTP,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor:
                        const Color(0xFF17887D), // Green button background
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // Message display
                Text(
                  _message,
                  style: TextStyle(
                    color: _message == 'OTP verified successfully'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create the OTP input fields
  Widget _buildOTPField(
      {required TextEditingController controller,
      required FocusNode? focusNode,
      required FocusNode? nextFocusNode}) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black, fontSize: 24),
        decoration: InputDecoration(
          counterText: '', // Hide the counter text
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black45), // White underline
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xFF17887D)), // Green underline when focused
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && nextFocusNode != null) {
            FocusScope.of(context)
                .requestFocus(nextFocusNode); // Move to the next field
          }
        },
      ),
    );
  }
}
