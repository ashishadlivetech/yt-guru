import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final box = GetStorage();
  var mobileNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadMobileNumber();
  }

  void loadMobileNumber() {
    mobileNumber.value =
        box.read('mobile_number') ?? ''; // ✅ Load stored mobile number
    print(
        "Loaded Mobile Number: ${mobileNumber.value}"); // ✅ Debugging statement
  }

  void setMobileNumber(String number) {
    mobileNumber.value = number;
    box.write('mobile_number', number); // ✅ Save mobile number
    print(
        "Saved Mobile Number: ${mobileNumber.value}"); // ✅ Debugging statement
  }
}
