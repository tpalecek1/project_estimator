import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<bool> checkAndRequestStoragePermissions() async {
    PermissionStatus permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted) {
      final status = await Permission.storage.request();
      return status == PermissionStatus.granted;
    } else {
      return true;
    }
  }
}