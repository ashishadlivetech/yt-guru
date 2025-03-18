import 'package:flutter/material.dart';
import 'package:project1/controllers/points_addservice.dart';
import 'package:project1/controllers/user_controller.dart';
import 'package:project1/theme_controller.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ShakeWinPage extends StatefulWidget {
  const ShakeWinPage({super.key});

  @override
  _ShakeWinPageState createState() => _ShakeWinPageState();
}

class _ShakeWinPageState extends State<ShakeWinPage> {
  double _progress = 0.0;
  String _statusText = "Shake & Win!";
  String _progressMessage = "Your reward will be displayed here";
  final ThemeController themeController = Get.find();
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      double acceleration = event.x.abs() + event.y.abs() + event.z.abs();
      if (acceleration > 20) {
        _updateProgress();
      }
    });
  }

  bool _canShake() {
    String? lastShakeTimeStr = box.read('last_shake_time');
    if (lastShakeTimeStr == null) return true;

    DateTime lastShakeTime = DateTime.parse(lastShakeTimeStr);
    DateTime now = DateTime.now();

    return now.difference(lastShakeTime).inHours >= 3; // 3-hour limit
  }

  Future<void> _updateProgress() async {
    if (!_canShake()) {
      setState(() {
        _progressMessage = "You can shake again after 3 hours!";
      });
      return;
    }
    if (!mounted) return; // Prevents calling setState on disposed widget

    if (_progress < 1.0) {
      setState(() {
        _progress += 0.1;
      });
    } else {
      if (mounted) {
        setState(() {
          _progressMessage = "Congratulations, you earned 281 points!";
        });
      }

      box.write('last_shake_time', DateTime.now().toIso8601String());
      PointsAddservice.creditCoins(281);
      final userController = Get.find<UserController>(); // ✅ Get UserController
      await userController.fetchUserData(forceRefresh: true);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          'Shake & Win',
          style: TextStyle(
              color: themeController.isDarkMode ? Colors.white : Colors.black),
        ),
        centerTitle: true,
        backgroundColor:
            themeController.isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: themeController.isDarkMode ? Colors.white : Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: themeController.isDarkMode
                    ? Color(0xFF131225)
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeController.isDarkMode
                          ? Colors.grey
                          : Colors.blueGrey,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/shake_icon.png',
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _statusText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Shake your phone every 3 hours and get a chance to earn points, try it now.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: themeController.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.grey[800],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _progressMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: themeController.isDarkMode
                            ? Colors.white
                            : Colors.black),
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
