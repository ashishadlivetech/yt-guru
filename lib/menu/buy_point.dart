import 'package:flutter/material.dart';
import 'package:project1/button_styles.dart';
import 'package:project1/controllers/user_controller.dart';
import 'package:project1/theme_controller.dart';
// Ensure this file contains ButtonStyles
import 'package:get/get.dart';

class BuyPointPage extends StatelessWidget {
  final UserController userController = Get.find();
  final ThemeController themeController = Get.find();
  final List<String> packageNames = [
    '3,000 coins',
    '10,000 coins',
    '50,000 coins',
    '250,000 coins',
    '500,000 coins',
    '1,000,000 coins'
  ];

  BuyPointPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text('Buy Points',
            style: TextStyle(
                color:
                    themeController.isDarkMode ? Colors.white : Colors.black)),
        centerTitle: true,
        backgroundColor:
            themeController.isDarkMode ? Colors.black : Colors.grey,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeController.isDarkMode ? Colors.white : Colors.black,
          ), // White back icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Row(
            children: [
              Obx(() => Text(
                    userController
                        .userPoints.value, // 🔹 Display dynamic points
                    style: TextStyle(
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontSize: 16,
                    ),
                  )),
              SizedBox(width: 5),
              Icon(Icons.favorite,
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.black),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'For your problems and questions, contact info.ytgroup@gmail.com',
              style: TextStyle(
                fontSize: 14,
                color: themeController.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: packageNames.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode
                          ? Color(0xFF131225)
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: themeController.isDarkMode
                              ? Colors.black.withOpacity(0.5)
                              : Colors.white.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            size: 40),
                        SizedBox(height: 8),
                        Text(
                          packageNames[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: ButtonStyles.gradientButton,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Buy',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
