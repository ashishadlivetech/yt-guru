import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project1/api_services/login_otp/otp_services.dart';
import 'package:project1/controllers/mobile_controler.dart';
import 'package:project1/controllers/user_controller.dart';
import 'package:project1/logo_screen.dart';
import 'theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await GetStorage.init();
  // Initialize storage for theme settings
  Get.put(AuthController());
  Get.put(ThemeController()); // Theme management
  Get.put(UserController());
  // Get.put(OtpService(), permanent: true);
  runApp(IntroApp());
}

class IntroApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  final UserController userController = Get.find();
  //final OtpService otpService =
  //   Get.find<OtpService>(); // Ensure it's registered

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Theme App',
          theme: ThemeData.light(), // Light Mode Theme
          darkTheme: ThemeData.dark(), // Dark Mode Theme
          themeMode:
              themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: Logoscreen(), // Home screen of the app
        ));
  }
}
