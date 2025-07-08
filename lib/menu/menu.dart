import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/controllers/user_controller.dart';
import 'package:project1/theme_controller.dart';
import '../controllers/mobile_controler.dart';
import '../google/login_api.dart' show GoogleSignInService;
import '../intro_screen.dart' show IntroScreen;
import '../play_store_iap.dart' show PlayStoreIAPPage;
import 'buy_point.dart';
import 'privacyploicy.dart';
import 'shakewin.dart';
import 'userprofile.dart';
import 'vipmemeber.dart';
import 'youtube_tools.dart';
import 'package:google_sign_in/google_sign_in.dart';


class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final ThemeController themeController = Get.find();
  final UserController userController = Get.find();
  final AuthController authController = Get.find();


  final List<Map<String, dynamic>> menuItems = [
    {
      "label": "Buy point",
      "icon": Icons.shopping_cart,
      "page": () => PlayStoreIAPPage()
    },
    {
      "label": "Become a VIP member",
      "icon": Icons.star,
      "page": () => VIPMembershipPage()
    },
    {
      "label": "Watch award-winning ads",
      "icon": Icons.favorite,
      "page": () => WatchAdsPage()
    },
    {
      "label": "Shake & win",
      "icon": Icons.casino,
      "page": () => ShakeWinPage()
    },
    {
      "label": "YouTube tools",
      "icon": Icons.ondemand_video,
      "page": () => YouTubeToolsPage()
    },
    {
      "label": "Frequently asked questions",
      "icon": Icons.question_answer,
      "page": () => FAQPage()
    },
    {
      "label": "Privacy policy",
      "icon": Icons.privacy_tip,
      "page": () => PrivacyPolicyPage()
    },
    {
      "label": "Share the app",
      "icon": Icons.share,
      "page": () => ShareAppPage()
    },
    {
      "label": "Rate the app",
      "icon": Icons.star_border,
      "page": () => RateAppPage()
    },
    {
      "label": "Contact us",
      "icon": Icons.contact_mail,
      "page": () => ContactUsPage()
    },
    {
      "label": "Log Out",
      "icon": Icons.contact_mail,
      "page": () => Logout()
    },
  ];

  @override
  void initState() {
    super.initState();
    if (userController.userName.value.isEmpty) {
      userController.fetchUserData(
          forceRefresh: true); // ✅ Fetch user data only if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor:
          themeController.isDarkMode ? Color(0xFF131225) : Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: screenHeight * 0.4,
                color: Colors.black,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode
                        ? Color(0xFF131225)
                        : Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 🔹 White Container
          Positioned(
            top: screenHeight * 0.1,
            bottom: screenHeight * 0.01,
            left: 20,
            right: 20,
            child: Container(
              height: screenHeight * 0.7,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeController.isDarkMode
                    ? Color(0xFF1A1A2E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          themeController.isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                        onPressed: () {
                          themeController.toggleTheme();
                        },
                      ),
                    ],
                  ),

                  // 🔹 Profile Section
                  InkWell(
                    onTap: () async {
                      await Get.to(() =>
                          UserProfilePage()); // ✅ Wait for profile page to close
                      userController.fetchUserData(
                          forceRefresh: true); // ✅ Refresh when returning
                    },
                    child: Obx(() {
                      return Row(
                        children: [
                          // ✅ Profile Image (Updates Instantly)
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: userController
                                    .userImage.value.isNotEmpty
                                ? NetworkImage(userController.userImage.value)
                                : null,
                            child: userController.userImage.value.isEmpty
                                ? Text(
                                    userController.userName.value.isNotEmpty
                                        ? userController.userName.value[0]
                                            .toUpperCase()
                                        : "U",
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userController.userName.value.isNotEmpty
                                      ? userController.userName.value
                                      : "User",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  authController.email.value.isNotEmpty
                                      ? authController.email.value
                                      : "user@example.com",
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),

                  const SizedBox(height: 25),

                  // 🔹 Menu Items
                  Expanded(
                    child: ListView.separated(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Get.to(
                                menuItems[index]['page'] as Widget Function());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              children: [
                                Icon(menuItems[index]['icon'],
                                    color: themeController.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    size: 24),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    menuItems[index]['label'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: themeController.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(color: Colors.grey, height: 18);
                      },
                    ),
                  ),

                  // 🔹 Bottom Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Version: 2.3.3",
                          style: TextStyle(fontSize: 13, color: Colors.grey)),
                      Text("ytGuru",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder pages
class WatchAdsPage extends StatelessWidget {
  const WatchAdsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Watch Ads")),
        body: const Center(child: Text("Watch ads page content")));
  }
}

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Frequently Asked Questions")),
        body: const Center(child: Text("FAQ page content")));
  }
}

class ShareAppPage extends StatelessWidget {
  const ShareAppPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Share the App")),
        body: const Center(child: Text("Share the app page content")));
  }
}

class RateAppPage extends StatelessWidget {
  const RateAppPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Rate the App")),
        body: const Center(child: Text("Rate the app page content")));
  }
}

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Contact Us")),
        body: const Center(child: Text("Contact us page content")));
  }
}


class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    // Schedule logout and navigation after build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await googleSignOut(context); // <-- your sign-out logic here
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const IntroScreen()),
            (route) => false, // removes all previous routes
      );
    });

    // Temporary screen while signing out
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

Future googleSignOut(BuildContext context) async {
  try {
    await GoogleSignInService.logout();
    log('Sign Out Success');
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Sign Out Success')));
    }
  } catch (exception) {
    log(exception.toString());
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Sign Out Failed')));
    }
  }
}