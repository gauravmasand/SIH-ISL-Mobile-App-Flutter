import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Service to handle ISL (Indian Sign Language) to text conversion
class PermissionServices {

  // Request camera permission
  static Future<void> requestPermissions({required dynamic action}) async {
    // Request the camera permission
    PermissionStatus cameraStatus = await Permission.camera.request();

    if (cameraStatus.isGranted) {
      print("Camera permission granted.");
      action();
    } else {
      print("Camera permission denied.");
    }
  }

}