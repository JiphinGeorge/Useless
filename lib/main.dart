import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'alarm_home_page.dart';
import 'permission_handler.dart'; // Import the permission handler

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure initialization
  tz.initializeTimeZones(); // Initialize timezone data
  await requestPermission(); // Request notification permission
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Negotiation Alarm App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AlarmHomePage(),
    );
  }
}
