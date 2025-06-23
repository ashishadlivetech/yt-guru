// // import 'dart:io';

// // import 'package:get/get.dart';
// // import 'package:get_storage/get_storage.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:project1/controllers/mobile_controler.dart';
// // import 'dart:convert';

// // class UserController extends GetxController {
// //   var userName = "".obs;
// //   var userEmail = "".obs;
// //   var userGender = "".obs;
// //   var userDOB = "".obs; // Store Date of Birth
// //   var userImage = "".obs;
// //   var userPoints = "0".obs;
// //   var isLoading = true.obs; // ✅ Add loading state

// //   final AuthController authController = Get.find();
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     fetchUserData(); // ✅ Automatically fetch profile data on app start
// //     ever(userPoints, (_) {
// //       update();
// //     });
// //   }

// //   void updatePoints(int newPoints) {
// //     userPoints.value = newPoints.toString(); // ✅ Correct conversion
// //     update();
// //   }

// //   Future<void> fetchUserData({bool forceRefresh = false}) async {
// //     if (!forceRefresh && userName.value.isNotEmpty) {
// //       print("✅ Using cached profile data, skipping API call.");
// //       return;
// //     }

// //     isLoading.value = true;

// //     String mobileNumber = authController.mobileNumber.value;
// //     if (mobileNumber.isEmpty) {
// //       print("🚨 Mobile number is missing!");
// //       isLoading.value = false;
// //       return;
// //     }

// //     final box = GetStorage();

// //     // ✅ Load cached data first (Avoids flickering)
// //     userName.value = box.read('user_name') ?? "";
// //     userEmail.value = box.read('user_email') ?? "";
// //     userGender.value = box.read('user_gender') ?? "";
// //     userDOB.value = box.read('user_dob') ?? "";
// //     userPoints.value = box.read('earning_point') ?? "0";
// //     String storedImage = box.read('user_img') ?? "";

// //     try {
// //       print("📥 Fetching latest profile from API...");
// //       final response = await http.post(
// //         Uri.parse("https://indianradio.in/yt-social-api/v1"),
// //         headers: {"Content-Type": "application/x-www-form-urlencoded"},
// //         body: {"method": "get_profile", "mobile_number": mobileNumber},
// //       );

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);

// //         if (data['status'] == "success") {
// //           final profile = data['0'];

// //           // ✅ Store new data, but keep stored image if API doesn't return it
// //           box.write('user_name', profile['name']);
// //           box.write('user_email', profile['email']);
// //           box.write('user_gender', profile['gender']);
// //           box.write('user_dob', profile['dob']);
// //           box.write('earning_point', profile['earning_point']);
// //           if (profile.containsKey('img') && profile['img'].isNotEmpty) {
// //             box.write('user_img', profile['img']);
// //           }

// //           // ✅ Update UI
// //           userName.value = profile['name'];
// //           userEmail.value = profile['email'];
// //           userGender.value = profile['gender'];
// //           userDOB.value = profile['dob'];
// //           userPoints.value = profile['earning_point'];
// //           userPoints.refresh();
// //           // ✅ Force GetX to detect change

// //           Future.delayed(Duration(milliseconds: 100), () {
// //             userPoints.value = profile['earning_point']; // ✅ Assign new value
// //             userPoints.refresh(); // ✅ Force UI to rebuild
// //             update(); // ✅ Ensure GetX updates the UI
// //           });

// //           // ✅ Keep existing image if API does not return one
// //           if (profile.containsKey('img') && profile['img'].isNotEmpty) {
// //             userImage.value = profile['img'];
// //           } else {
// //             userImage.value = storedImage;
// //           }

// //           print("✅ Profile updated: ${userName.value}, ${userImage.value}");
// //         } else {
// //           print("❌ API Error: ${data['message']}");
// //         }
// //       } else {
// //         print("❌ Failed to fetch user data.");
// //       }
// //     } catch (e) {
// //       print("❌ Error fetching user data: $e");
// //     }

// //     isLoading.value = false;
// //   }

// //   // 🔹 Update user data in API (Includes Name, Gender & DOB)
// //   Future<void> updateUserData(
// //       String name, String email, String gender, String dob) async {
// //     String mobileNumber = authController.mobileNumber.value;
// //     String existingImageUrl =
// //         userImage.value; // ✅ Preserve the existing profile image

// //     if (mobileNumber.isEmpty) {
// //       print("🚨 Mobile number is missing!");
// //       return;
// //     }

// //     final Map<String, String> requestData = {
// //       "method": "profile",
// //       "mobile_number": mobileNumber,
// //       "name": name,
// //       "email": email,
// //       "gender": gender,
// //       "dob": dob,
// //       "img": existingImageUrl.isNotEmpty
// //           ? existingImageUrl
// //           : "" // ✅ Keep the existing image
// //     };

// //     print("📤 Sending Update Request: $requestData");

// //     try {
// //       final response = await http.post(
// //         Uri.parse("https://indianradio.in/yt-social-api/v1"),
// //         headers: {"Content-Type": "application/x-www-form-urlencoded"},
// //         body: requestData,
// //       );

// //       print("📥 Response Status: ${response.statusCode}");
// //       print("📥 Response Body: ${response.body}");

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         if (data['status'] == "success") {
// //           userName.value = name;
// //           userEmail.value = email;
// //           userGender.value = gender;
// //           userDOB.value = dob;
// //           userImage.value = existingImageUrl; // ✅ Retain the existing image
// //           userPoints.refresh();
// //           print("✅ Profile updated successfully!");
// //         } else {
// //           print("❌ API Error: ${data['message']}");
// //         }
// //       } else {
// //         print("❌ Failed to update user data: ${response.statusCode}");
// //       }
// //     } catch (e) {
// //       print("❌ Error updating user data: $e");
// //     }
// //   }

// //   Future<void> uploadProfileImage(File imageFile) async {
// //     String mobileNumber = authController.mobileNumber.value;
// //     if (mobileNumber.isEmpty) {
// //       print("🚨 Mobile number is missing!");
// //       return;
// //     }

// //     var request = http.MultipartRequest(
// //         "POST", Uri.parse("https://indianradio.in/yt-social-api/v1"));
// //     request.fields["method"] = "profile";
// //     request.fields["mobile_number"] = mobileNumber;
// //     request.fields["name"] = userName.value;
// //     request.fields["email"] = userEmail.value;
// //     request.fields["gender"] = userGender.value;
// //     request.fields["dob"] = userDOB.value;
// //     request.files.add(await http.MultipartFile.fromPath("img", imageFile.path));

// //     try {
// //       var response = await request.send();
// //       var responseData = await response.stream.bytesToString();
// //       var jsonResponse = jsonDecode(responseData);

// //       print("📤 Image Upload Response: $jsonResponse");

// //       if (jsonResponse['status'] == "success") {
// //         String newImageUrl =
// //             jsonResponse.containsKey('img') ? jsonResponse['img'] : "";

// //         if (newImageUrl.isNotEmpty) {
// //           // ✅ Store new image URL in GetStorage
// //           GetStorage().write('user_img', newImageUrl);
// //           userImage.value = newImageUrl; // ✅ Update UI immediately

// //           print("✅ Profile image updated: $newImageUrl");
// //         }

// //         // ✅ Fetch updated profile data after storing new image
// //         fetchUserData(forceRefresh: true);
// //       } else {
// //         print("❌ Failed to update profile image: ${jsonResponse['message']}");
// //       }
// //     } catch (e) {
// //       print("❌ Error uploading image: $e");
// //     }
// //   }

// //   // 🔹 Delete Account
// //   Future<void> deleteAccount() async {
// //     String mobileNumber = authController.mobileNumber.value;
// //     if (mobileNumber.isEmpty) {
// //       print("Mobile number is missing!");
// //       return;
// //     }

// //     try {
// //       final response = await http.post(
// //         Uri.parse("https://indianradio.in/yt-social-api/v1"),
// //         headers: {"Content-Type": "application/x-www-form-urlencoded"},
// //         body: {
// //           "method": "delete", // ✅ Correct method
// //           "mobile_number": mobileNumber,
// //         },
// //       );

// //       if (response.statusCode == 200) {
// //         userName.value = "";
// //         userEmail.value = "";
// //         userGender.value = "";
// //         userDOB.value = "";
// //         print("Account deleted successfully");
// //       } else {
// //         print("Failed to delete account");
// //       }
// //     } catch (e) {
// //       print("Error deleting account: $e");
// //     }
// //   }
// // }
// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:project1/controllers/mobile_controler.dart';
// import 'dart:convert';

// class UserController extends GetxController {
//   var userName = "".obs;
//   var userEmail = "".obs;
//   var userGender = "".obs;
//   var userDOB = "".obs; // Store Date of Birth
//   var userImage = "".obs;
//   var userPoints = "0".obs;
//   var isLoading = true.obs; // ✅ Add loading state
//   RxString userMobile = "".obs; // Define userMobile here

//   final AuthController authController = Get.find();

//   @override
//   void onInit() {
//     super.onInit();
//     fetchUserData(); // ✅ Automatically fetch profile data on app start
//     ever(userPoints, (_) {
//       update();
//     });
//   }

//   void updatePoints(int newPoints) {
//     userPoints.value = newPoints.toString(); // ✅ Correct conversion
//     update();
//   }

//   Future<void> fetchUserData({bool forceRefresh = false}) async {
//     if (!forceRefresh && userName.value.isNotEmpty) {
//       print("✅ Using cached profile data, skipping API call.");
//       return;
//     }

//     isLoading.value = true;

//     String email =
//         authController.email.value; // Use email instead of mobileNumber
//     if (email.isEmpty) {
//       print("🚨 Email is missing!");
//       isLoading.value = false;
//       return;
//     }

//     final box = GetStorage();

//     // ✅ Load cached data first (Avoids flickering)
//     userName.value = box.read('user_name') ?? "";
//     userEmail.value = box.read('user_email') ?? "";
//     userGender.value = box.read('user_gender') ?? "";
//     userDOB.value = box.read('user_dob') ?? "";
//     userPoints.value = box.read('earning_point') ?? "0";
//     String storedImage = box.read('user_img') ?? "";

//     try {
//       print("📥 Fetching latest profile from API...");
//       final response = await http.post(
//         Uri.parse("https://indianradio.in/yt-social-api/v1"),
//         headers: {"Content-Type": "application/x-www-form-urlencoded"},
//         body: {
//           "method": "get_profile",
//           "email": email
//         }, // Send email instead of mobile number
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data['status'] == "success") {
//           final profile = data['0'];

//           // ✅ Store new data, but keep stored image if API doesn't return it
//           box.write('user_name', profile['name']);
//           box.write('user_email', profile['email']);
//           box.write('user_gender', profile['gender']);
//           box.write('user_dob', profile['dob']);
//           box.write('earning_point', profile['earning_point']);
//           if (profile.containsKey('img') && profile['img'].isNotEmpty) {
//             box.write('user_img', profile['img']);
//           }

//           // ✅ Update UI
//           userName.value = profile['name'];
//           userEmail.value = profile['email'];
//           userGender.value = profile['gender'];
//           userDOB.value = profile['dob'];
//           userPoints.value = profile['earning_point'];
//           userPoints.refresh(); // Force GetX to detect change

//           // ✅ Keep existing image if API does not return one
//           if (profile.containsKey('img') && profile['img'].isNotEmpty) {
//             userImage.value = profile['img'];
//           } else {
//             userImage.value = storedImage;
//           }

//           print("✅ Profile updated: ${userName.value}, ${userImage.value}");
//         } else {
//           print("❌ API Error: ${data['message']}");
//         }
//       } else {
//         print("❌ Failed to fetch user data.");
//       }
//     } catch (e) {
//       print("❌ Error fetching user data: $e");
//     }

//     isLoading.value = false;
//   }

//   Future<void> updateUserData(
//       String name, String email, String gender, String dob) async {
//     String existingImageUrl =
//         userImage.value; // Preserve the existing profile image

//     if (email.isEmpty) {
//       print("🚨 Email is missing!");
//       return;
//     }

//     final Map<String, String> requestData = {
//       "method": "profile",
//       "email": email, // Use email instead of mobile number
//       "name": name,
//       "gender": gender,
//       "dob": dob,
//       "img": existingImageUrl.isNotEmpty
//           ? existingImageUrl
//           : "" // Keep the existing image
//     };

//     print("📤 Sending Update Request: $requestData");

//     try {
//       final response = await http.post(
//         Uri.parse("https://indianradio.in/yt-social-api/v1"),
//         headers: {"Content-Type": "application/x-www-form-urlencoded"},
//         body: requestData,
//       );

//       print("📥 Response Status: ${response.statusCode}");
//       print("📥 Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == "success") {
//           userName.value = name;
//           userEmail.value = email;
//           userGender.value = gender;
//           userDOB.value = dob;
//           userImage.value = existingImageUrl; // Retain the existing image
//           userPoints.refresh();
//           print("✅ Profile updated successfully!");
//         } else {
//           print("❌ API Error: ${data['message']}");
//         }
//       } else {
//         print("❌ Failed to update user data: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("❌ Error updating user data: $e");
//     }
//   }

//   Future<void> uploadProfileImage(File imageFile) async {
//     String email = authController.email.value;
//     if (email.isEmpty) {
//       print("🚨 Email is missing!");
//       return;
//     }

//     var request = http.MultipartRequest(
//         "POST", Uri.parse("https://indianradio.in/yt-social-api/v1"));
//     request.fields["method"] = "profile";
//     request.fields["email"] = email; // Use email instead of mobile number
//     request.fields["name"] = userName.value;
//     request.fields["gender"] = userGender.value;
//     request.fields["dob"] = userDOB.value;
//     request.files.add(await http.MultipartFile.fromPath("img", imageFile.path));

//     try {
//       var response = await request.send();
//       var responseData = await response.stream.bytesToString();
//       var jsonResponse = jsonDecode(responseData);

//       print("📤 Image Upload Response: $jsonResponse");

//       if (jsonResponse['status'] == "success") {
//         String newImageUrl =
//             jsonResponse.containsKey('img') ? jsonResponse['img'] : "";

//         if (newImageUrl.isNotEmpty) {
//           // Store new image URL in GetStorage
//           GetStorage().write('user_img', newImageUrl);
//           userImage.value = newImageUrl; // Update UI immediately

//           print("✅ Profile image updated: $newImageUrl");
//         }

//         // Fetch updated profile data after storing new image
//         fetchUserData(forceRefresh: true);
//       } else {
//         print("❌ Failed to update profile image: ${jsonResponse['message']}");
//       }
//     } catch (e) {
//       print("❌ Error uploading image: $e");
//     }
//   }

//   Future<void> deleteAccount() async {
//     String email = authController.email.value;
//     if (email.isEmpty) {
//       print("Email is missing!");
//       return;
//     }

//     try {
//       final response = await http.post(
//         Uri.parse("https://indianradio.in/yt-social-api/v1"),
//         headers: {"Content-Type": "application/x-www-form-urlencoded"},
//         body: {
//           "method": "delete", // ✅ Correct method
//           "email": email,
//         },
//       );

//       if (response.statusCode == 200) {
//         userName.value = "";
//         userEmail.value = "";
//         userGender.value = "";
//         userDOB.value = "";
//         print("Account deleted successfully");
//       } else {
//         print("Failed to delete account");
//       }
//     } catch (e) {
//       print("Error deleting account: $e");
//     }
//   }
// }
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project1/controllers/mobile_controler.dart';
import 'dart:convert';

class UserController extends GetxController {
  var userName = "".obs;
  var userEmail = "".obs;
  var userGender = "".obs;
  var userDOB = "".obs; // Store Date of Birth
  var userImage = "".obs;
  var userPoints = "0".obs;
  var isLoading = true.obs; // ✅ Add loading state
  RxString userMobile = "".obs; // Define userMobile here

  final AuthController authController = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchUserData(); // ✅ Automatically fetch profile data on app start
    ever(userPoints, (_) {
      update();
    });
  }

  void updatePoints(int newPoints) {
    userPoints.value = newPoints.toString(); // ✅ Correct conversion
    update();
  }

  Future<void> fetchUserData({bool forceRefresh = false}) async {
    if (!forceRefresh && userName.value.isNotEmpty) {
      print("✅ Using cached profile data, skipping API call.");
      return;
    }

    isLoading.value = true;

    String email = authController.email.value; // Use email from AuthController
    if (email.isEmpty) {
      print("🚨 Email is missing!");
      isLoading.value = false;
      return;
    }

    final box = GetStorage();

    // ✅ Load cached data first (Avoids flickering)
    userName.value = box.read('user_name') ?? "";
    userEmail.value = box.read('user_email') ?? "";
    userGender.value = box.read('user_gender') ?? "";
    userDOB.value = box.read('user_dob') ?? "";
    userPoints.value = box.read('earning_point') ?? "0";
    String storedImage = box.read('user_img') ?? "";

    try {
      print("📥 Fetching latest profile from API...");
      final response = await http.post(
        Uri.parse("https://indianradio.in/yt-social-api/v1"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "method": "get_profile",
          "email": email // Use email from AuthController
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == "success") {
          final profile = data['0'];

          // ✅ Store new data, but keep stored image if API doesn't return it
          box.write('user_name', profile['name'] ?? '');
          box.write('user_email', profile['email'] ?? '');
          box.write('user_gender', profile['gender'] ?? '');
          box.write('user_dob', profile['dob'] ?? '');
          box.write('earning_point', profile['earning_point'] ?? '0');
          /*if (profile.containsKey('img') && profile['img'].isNotEmpty) {
            box.write('user_img', profile['img']);
          }*/

          // ✅ Update UI
          userName.value = profile['name'] ?? '';
          userEmail.value = profile['email'] ?? '';
          userGender.value = profile['gender'] ?? '';
          userDOB.value = profile['dob'] ?? '';
          userPoints.value = profile['earning_point'] ?? '0';
          userPoints.refresh(); // Force GetX to detect change

          // ✅ Keep existing image if API does not return one
          /*if (profile.containsKey('img') && profile['img'].isNotEmpty) {
            userImage.value = profile['img'];
          } else {
            userImage.value = storedImage;
          }*/

          print("✅ Profile updated: ${userName.value}, ${userImage.value}");
        } else {
          print("❌ API Error: ${data['message']}");
        }
      } else {
        print("❌ Failed to fetch user data.");
      }
    } catch (e) {
      print("❌ Error fetching user data: $e");
    }

    isLoading.value = false;
  }

  // Future<void> updateUserData(
  //     String name, String gender, String dob) async {
  //   String email = authController.email.value; // Use email from AuthController
  //   String existingImageUrl = userImage.value; // Preserve the existing profile image

  //   if (email.isEmpty) {
  //     print("🚨 Email is missing!");
  //     return;
  //   }

  //   final Map<String, String> requestData = {
  //     "method": "profile",
  //     "email": email, // Use email from AuthController
  //     "name": name,
  //     "gender": gender,
  //     "dob": dob,
  //     "img": existingImageUrl.isNotEmpty
  //         ? existingImageUrl
  //         : "" // Keep the existing image
  //   };

  //   print("📤 Sending Update Request: $requestData");

  //   try {
  //     final response = await http.post(
  //       Uri.parse("https://indianradio.in/yt-social-api/v1"),
  //       headers: {"Content-Type": "application/x-www-form-urlencoded"},
  //       body: requestData,
  //     );

  //     print("📥 Response Status: ${response.statusCode}");
  //     print("📥 Response Body: ${response.body}");

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       if (data['status'] == "success") {
  //         userName.value = name;

  //         userGender.value = gender;
  //         userDOB.value = dob;
  //         userImage.value = existingImageUrl; // Retain the existing image
  //         userEmail.value = email;
  //         userPoints.refresh();
  //         print("✅ Profile updated successfully!");
  //       } else {
  //         print("❌ API Error: ${data['message']}");
  //       }
  //     } else {
  //       print("❌ Failed to update user data: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("❌ Error updating user data: $e");
  //   }
  // }
  Future<void> updateUserData(
      String name, String gender, String dob, String mobileNumber) async {
    String email = authController.email.value; // Use email from AuthController
    String existingImageUrl =
        userImage.value; // Preserve the existing profile image

    if (email.isEmpty) {
      print("🚨 Email is missing!");
      return;
    }

    final Map<String, String> requestData = {
      "method": "profile",
      "email": email, // Use email from AuthController
      "name": name,
      "gender": gender,
      "dob": dob,
      "mobile": mobileNumber, // Include the mobile number here
      "img": existingImageUrl.isNotEmpty
          ? existingImageUrl
          : "" // Keep the existing image
    };

    print("📤 Sending Update Request: $requestData");

    try {
      final response = await http.post(
        Uri.parse("https://indianradio.in/yt-social-api/v1"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: requestData,
      );

      print("📥 Response Status: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == "success") {
          userName.value = name;
          userEmail.value = email;
          userGender.value = gender;
          userDOB.value = dob;
          userMobile.value = mobileNumber; // Update mobile number in state
          userImage.value = existingImageUrl; // Retain the existing image
          userPoints.refresh();
          print("✅ Profile updated successfully!");
        } else {
          print("❌ API Error: ${data['message']}");
        }
      } else {
        print("❌ Failed to update user data: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error updating user data: $e");
    }
  }

  Future<void> uploadProfileImage(File imageFile) async {
    String email = authController.email.value; // Use email from AuthController
    if (email.isEmpty) {
      print("🚨 Email is missing!");
      return;
    }

    var request = http.MultipartRequest(
        "POST", Uri.parse("https://indianradio.in/yt-social-api/v1"));
    request.fields["method"] = "profile";
    request.fields["email"] = email; // Use email from AuthController
    request.fields["name"] = userName.value;
    request.fields["gender"] = userGender.value;
    request.fields["dob"] = userDOB.value;
    request.files.add(await http.MultipartFile.fromPath("img", imageFile.path));

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      print("📤 Image Upload Response: $jsonResponse");

      if (jsonResponse['status'] == "success") {
        String newImageUrl =
            jsonResponse.containsKey('img') ? jsonResponse['img'] : "";

        if (newImageUrl.isNotEmpty) {
          // Store new image URL in GetStorage
          GetStorage().write('user_img', newImageUrl);
          userImage.value = newImageUrl; // Update UI immediately

          print("✅ Profile image updated: $newImageUrl");
        }

        // Fetch updated profile data after storing new image
        fetchUserData(forceRefresh: true);
      } else {
        print("❌ Failed to update profile image: ${jsonResponse['message']}");
      }
    } catch (e) {
      print("❌ Error uploading image: $e");
    }
  }

  Future<void> deleteAccount() async {
    String email = authController.email.value; // Use email from AuthController
    if (email.isEmpty) {
      print("Email is missing!");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("https://indianradio.in/yt-social-api/v1"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "method": "delete", // ✅ Correct method
          "email": email, // Use email from AuthController
        },
      );

      if (response.statusCode == 200) {
        userName.value = "";
        userEmail.value = "";
        userGender.value = "";
        userDOB.value = "";
        print("Account deleted successfully");
      } else {
        print("Failed to delete account");
      }
    } catch (e) {
      print("Error deleting account: $e");
    }
  }
}
