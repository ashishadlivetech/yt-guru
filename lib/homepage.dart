import 'package:flutter/material.dart';
import 'package:project1/api_services/camp_deta.dart';
import 'package:project1/campaigndetail.dart';
import 'package:project1/controllers/user_controller.dart';
import 'package:project1/menu/menu.dart';
import 'package:project1/theme_controller.dart';
import 'package:project1/youtube.dart';
import 'package:project1/addcamp.dart';
import 'package:project1/like.dart';
import 'package:project1/subscribe.dart';
import 'package:project1/button_styles.dart';
import 'package:get/get.dart';
import 'package:project1/controllers/mobile_controler.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  final UserController userController = Get.find();
  final ThemeController themeController = Get.put(ThemeController());
  final CampData campData = CampData();
  final AuthController authController =
      Get.put(AuthController()); // ✅ Ensures it's initialized

  final RxList<Campaign> _campaigns = <Campaign>[].obs;
  final RxBool _isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    authController.loadMobileNumber(); // Ensure mobile number is loaded first
    print(
        "Loaded Mobile Number in initState: ${authController.mobileNumber.value}");
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
    try {
      _isLoading.value = true; // ✅ Start loading

      String mobileNumber = authController.mobileNumber.value;
      print("Fetched Mobile Number: $mobileNumber");

      if (mobileNumber.isEmpty) {
        print("Error: Mobile Number is empty!");
        return;
      }

      var campaigns = await campData.fetchCampaigns(mobileNumber);
      _campaigns.assignAll(campaigns); // ✅ UI updates immediately
    } catch (e) {
      print("Error loading campaigns: $e");
    } finally {
      _isLoading.value = false; // ✅ End loading
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor:
              themeController.isDarkMode ? Colors.black : Colors.white,
          body: Column(
            children: [
              // 🔹 Black Top Bar
              Container(
                width: MediaQuery.of(context).size.width,
                height: 115,
                color: themeController.isDarkMode ? Colors.black : Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu,
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          size: 30),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MenuPage()));
                      },
                    ),
                    Expanded(
                      child: Text(
                        "YtGuru",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Obx(() => Text(
                              userController.userPoints
                                  .value, // 🔹 Display dynamic points
                              style: TextStyle(
                                color: themeController.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                              ),
                            )),
                        SizedBox(width: 5),
                        Icon(Icons.favorite,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),

              // 🔹 Main Content Area
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode
                        ? Color(0xFF131225)
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: _selectedIndex == 0
                      ? _buildHomeContent()
                      : _getSelectedPage(),
                ),
              ),
            ],
          ),

          // 🔹 Floating Action Button
          floatingActionButton: _selectedIndex == 0
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddCampaignPage()),
                    ).then((_) => _loadCampaigns()); // ✅ Refresh on return
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: ButtonStyles.gradientButton,
                    child: const Icon(Icons.add, color: Colors.white, size: 42),
                  ),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

          // 🔹 Bottom Navigation Bar
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor:
                themeController.isDarkMode ? Colors.black : Colors.white,
            selectedItemColor: Colors.orange,
            unselectedItemColor:
                themeController.isDarkMode ? Colors.white : Colors.black,
            selectedLabelStyle: const TextStyle(fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.message, size: 26), label: "Message"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.ondemand_video, size: 26), label: "View"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.subscriptions, size: 26),
                  label: "Subscribe"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.thumb_up, size: 26), label: "Like"),
            ],
          ),
        ));
  }

  Widget _buildHomeContent() {
    return Obx(() {
      if (_isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_campaigns.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Campaign not found.",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Press the + button to create a campaign.",
                style: TextStyle(
                  fontSize: 16,
                  color: themeController.isDarkMode
                      ? Colors.white70
                      : Colors.black87,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _campaigns.length,
        itemBuilder: (context, index) {
          final campaign = _campaigns[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CampaignDetailsPage(
                    campaignId: campaign.id.toString(),
                    mobileNumber: authController.mobileNumber.value,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: themeController.isDarkMode
                    ? Colors.grey[900]
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: themeController.isDarkMode
                    ? []
                    : [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            spreadRadius: 1)
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID: ${campaign.id}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  if (campaign.viewTime != null && campaign.viewCost != null)
                    Text(
                        "View Time: ${campaign.viewTime}, View Points: ${campaign.viewCost}"),
                  if (campaign.subTime != null && campaign.subCost != null)
                    Text(
                        "Subscribe Time: ${campaign.subTime}, Subscribe Points: ${campaign.subCost}"),
                  if (campaign.likeTime != null && campaign.likeCost != null)
                    Text(
                        "Like Time: ${campaign.likeTime}, Like Points: ${campaign.likeCost}"),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 1:
        return const YouTubePage();
      case 2:
        return const Subscribe();
      case 3:
        return const Like();
      default:
        return SizedBox.shrink();
    }
  }
}
