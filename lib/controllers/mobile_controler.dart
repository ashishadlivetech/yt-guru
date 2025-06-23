// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class AuthController extends GetxController {
//   final box = GetStorage();
//   var mobileNumber = ''.obs;
//   var email = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadMobileNumber();
//   }

//   void loadMobileNumber() {
//     mobileNumber.value =
//         box.read('mobile_number') ?? ''; // ✅ Load stored mobile number
//     print(
//         "Loaded Mobile Number: ${mobileNumber.value}"); // ✅ Debugging statement
//   }

//   void setMobileNumber(String number) {
//     mobileNumber.value = number;
//     box.write('mobile_number', number); // ✅ Save mobile number
//     print(
//         "Saved Mobile Number: ${mobileNumber.value}"); // ✅ Debugging statement
//   }

//   void setEmail(String emailId){
//     email.value=emailId;
//     box.write('email', email);
//   }

//   void getEmail(){
//     email.value =
//         box.read('email') ?? '';
//   }
// }
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class AuthController extends GetxController {
//   final box = GetStorage();
//   //var mobileNumber = ''.obs;
//   var email = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     //loadMobileNumber();
//     getEmail(); // Ensure to load the email when the controller initializes
//   }

//   // void loadMobileNumber() {
//   //   mobileNumber.value = box.read('mobile_number') ?? '';
//   //   print("Loaded Mobile Number: ${mobileNumber.value}");
//   // }

//   // void setMobileNumber(String number) {
//   //   mobileNumber.value = number;
//   //   box.write('mobile_number', number);
//   //   print("Saved Mobile Number: ${mobileNumber.value}");
//   // }

//   void setEmail(String emailId) {
//     // Ensure email is a String before saving
//     if (emailId is String) {
//       email.value = emailId;
//       box.write('email', emailId);
//       print(
//           "Saved Email: ${email.value}"); // This will print the saved email in the console
//     } else {
//       print("Invalid email type");
//     }
//   }

//   void getEmail() {
//     String storedEmail = box.read('email') ?? '';
//     email.value = storedEmail; // Load the email from storage
//     print(
//         "Loaded Email: $storedEmail"); // This will print the loaded email in the console
//   }
// }

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final box = GetStorage();
  final FlutterSecureStorage secureStorage =
      FlutterSecureStorage(); // Create an instance of FlutterSecureStorage
  var email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getEmail(); // Ensure to load the email when the controller initializes
  }

  // Save the email to GetStorage (no need to change this part)
  void setEmail(String emailId) {
    email.value = emailId;
    box.write('email', emailId);
    print("Saved Email: ${email.value}");
  }

  // Load the email from GetStorage (no need to change this part)
  void getEmail() {
    String storedEmail = box.read('email') ?? '';
    email.value = storedEmail;
    print("Loaded Email: $storedEmail");
  }

  // Save the access token securely
  Future<void> setAccessToken(String token) async {
    await secureStorage.write(
        key: 'accessToken', value: token); // Save the token securely
    print("Saved Access Token");
  }

  // Retrieve the access token securely
  Future<String?> getAccessToken() async {
    String? token = await secureStorage.read(
        key: 'accessToken'); // Retrieve the token securely
    return token;
  }

  // Delete the access token securely (optional, when the user logs out)
  Future<void> deleteAccessToken() async {
    await secureStorage.delete(key: 'accessToken'); // Delete the token securely
    print("Deleted Access Token");
  }


   Future<String?> getYoutubeAccessToken() async {
    String? token = await secureStorage.read(
        key: 'YoutubeaccessToken'); // Retrieve the token securely
    return token;
  }

   Future<void> saveYoutubeAccessToken(String token) async {
    await secureStorage.write(key: 'YoutubeaccessToken', value: token);
  }

   Future<void> clearYouTubeAccessToken() async {
    await secureStorage.delete(key: 'YoutubeaccessToken');
  }

}
