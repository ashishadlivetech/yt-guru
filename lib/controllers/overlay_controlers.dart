import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:get/get.dart';

class OverlayController extends GetxController {
  Future<void> openWebViewOverlay() async {
    bool granted = await FlutterOverlayWindow.isPermissionGranted();
    if (!granted) {
      await FlutterOverlayWindow.requestPermission();
    }

    await FlutterOverlayWindow.showOverlay(
      height: 500,
      width: 300,
      overlayTitle: "YouTube Video",
      overlayContent: "Watch & Earn",
      enableDrag: true,
    );
  }
}
