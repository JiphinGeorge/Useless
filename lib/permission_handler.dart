import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermission() async {
  // Request notification permissions
  final status = await Permission.notification.request();
  if (status.isGranted) {
    // Permission granted, do nothing
  } else {
    // Permission denied, you may want to show a message to the user
  }
}
