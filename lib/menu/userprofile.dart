import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/button_styles.dart';
import 'package:project1/controllers/mobile_controler.dart';
import 'package:project1/controllers/user_controller.dart';
import 'package:project1/logo_screen.dart';
import 'package:project1/theme_controller.dart';
import 'package:get/get.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final UserController userController = Get.find();
  final ThemeController themeController = Get.find();
  final AuthController authController = Get.find();
  File? _imageFile;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // ✅ Store selected image before upload
      GetStorage().write('user_img', imageFile.path);

      // ✅ Show selected image instantly in UI
      setState(() {
        _imageFile = imageFile;
        userController.userImage.value = imageFile.path;
      });

      // ✅ Upload the image
      await userController.uploadProfileImage(imageFile);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await userController.fetchUserData(); // ✅ Fetch latest API data

    setState(() {
      // ✅ Keep input fields empty
      _fullNameController.text = "";
      _emailController.text = "";
      _selectedGender = null;
      _selectedDate = null;
    });
  }

  Future<void> _submitData() async {
    String fullName = _fullNameController.text;
    String email = _emailController.text;
    String gender = _selectedGender ?? "";

    // ✅ Convert Date to DD-MM-YY Format
    String dob = _selectedDate != null
        ? "${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year.toString().substring(2)}"
        : "";

    // ✅ Validate DOB
    if (dob.isNotEmpty && !_isValidDOB(dob)) {
      Get.snackbar("Error", "Invalid Date of Birth format. Use DD-MM-YY",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (fullName.isNotEmpty && email.isNotEmpty) {
      await userController.updateUserData(fullName, email, gender, dob);
      await _loadUserData();
      _fullNameController.clear();
      _emailController.clear();
      _selectedGender = null;
      _selectedDate = null;
      // ✅ Refresh UI after update
      await userController.fetchUserData();
      setState(() {});
      Get.snackbar("Success", "Profile Updated Successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.back();
    } else {
      Get.snackbar("Error", "All fields are required",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  bool _isValidDOB(String dob) {
    // ✅ Check Format: Must be DD-MM-YY (6 digits + 2 hyphens)
    final RegExp dobPattern = RegExp(r'^\d{2}-\d{2}-\d{2}$');
    if (!dobPattern.hasMatch(dob)) return false;

    // ✅ Extract Day, Month, and Year
    List<String> parts = dob.split('-');
    int day = int.tryParse(parts[0]) ?? 0;
    int month = int.tryParse(parts[1]) ?? 0;
    int year = int.tryParse(parts[2]) ?? -1; // Two-digit year

    // ✅ Validate Month (1-12)
    if (month < 1 || month > 12) return false;

    // ✅ Validate Day (1-31)
    if (day < 1 || day > 31) return false;

    // ✅ Check if the day is valid for the given month
    try {
      DateTime testDate = DateTime(2000 + year, month, day); // Assumes 20XX
      return testDate.day == day;
    } catch (e) {
      return false; // Invalid date
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime initialDate = _selectedDate ?? currentDate;
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = currentDate;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFF50E4A4),
              onPrimary: Colors.black,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor:
                themeController.isDarkMode ? Color(0xFF131225) : Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _deleteAccount() async {
    bool confirmDelete = await Get.dialog(
      AlertDialog(
        title: Text("Delete Account"),
        content: Text(
            "Are you sure you want to delete your account? This action cannot be undone."),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false), child: Text("Cancel")),
          TextButton(
              onPressed: () => Get.back(result: true),
              child: Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmDelete) {
      await userController.deleteAccount();
      final box = GetStorage();
      box.remove('mobile_number');
      authController.setMobileNumber("");
      Get.offAll(() => Logoscreen());
    }
  }

  @override
  void dispose() {
    userController.fetchUserData(); // ✅ Refresh profile when exiting
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          themeController.isDarkMode ? Color(0xFF131225) : Colors.white,
      appBar: AppBar(
        backgroundColor:
            themeController.isDarkMode ? Colors.black : Colors.white,
        title: Text("My Account",
            style: TextStyle(
                color:
                    themeController.isDarkMode ? Colors.white : Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: themeController.isDarkMode ? Colors.white : Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 🔹 Profile Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: themeController.isDarkMode
                      ? Color(0xFF1A1A2E)
                      : Colors.white60,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(() {
                  // ✅ Show a loading indicator if data is still loading
                  if (userController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return Row(
                    children: [
                      // 🔹 Profile Picture
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              userController.userImage.value.isNotEmpty
                                  ? NetworkImage(userController.userImage.value)
                                  : null,
                          child: userController.userImage.value.isEmpty
                              ? Text(
                                  userController.userName.value.isNotEmpty
                                      ? userController.userName.value[0]
                                          .toUpperCase()
                                      : "U",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold))
                              : null,
                        ),
                      ),
                      const SizedBox(width: 15),

                      // 🔹 User Name & Email
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Account name",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            Text(
                              userController.userName.value.isNotEmpty
                                  ? userController.userName.value
                                  : "username",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text("Account Email",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                            Text(
                              userController.userEmail.value.isNotEmpty
                                  ? userController.userEmail.value
                                  : "user@gmail.com",
                              style: TextStyle(fontSize: 14),
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
            ),

            const SizedBox(height: 20),

            // 🔹 Delete Account Button (BELOW PROFILE SECTION)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: GestureDetector(
                onTap: _deleteAccount,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: ButtonStyles.gradientButton,
                  child: const Center(
                    child: Text("Delete My Account",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 🔹 User Data Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(labelText: "Full Name")),
                  const SizedBox(height: 10),
                  TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "Email")),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    items: ["Male", "Female", "Other"].map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    decoration: InputDecoration(labelText: "Gender"),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Date of Birth"),
                        controller: TextEditingController(
                          text: _selectedDate != null
                              ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                              : "",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: GestureDetector(
                onTap: _submitData,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: ButtonStyles.gradientButton,
                  child: const Center(
                    child: Text("Submit",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 🔹 Text Column Below Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Purchase History",
                    style: TextStyle(
                        color: themeController.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "no purchase history",
                    style: TextStyle(
                        color: themeController.isDarkMode
                            ? Colors.white70
                            : Colors.black45,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
