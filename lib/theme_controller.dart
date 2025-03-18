import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage(); // Local storage for saving theme preference
  final _isDarkMode = false.obs;

  ThemeController() {
    _isDarkMode.value = _storage.read('isDarkMode') ?? false;
  }

  bool get isDarkMode => _isDarkMode.value;

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _storage.write('isDarkMode', _isDarkMode.value); // Save preference
  }
}
