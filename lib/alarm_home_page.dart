import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'alarm_set_page.dart';

class AlarmHomePage extends StatefulWidget {
  @override
  _AlarmHomePageState createState() => _AlarmHomePageState();
}

class _AlarmHomePageState extends State<AlarmHomePage> {
  bool _alarmRinging = false;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _setAlarm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlarmSetPage(
          flutterLocalNotificationsPlugin: _flutterLocalNotificationsPlugin,
          onAlarmRinging: _ringAlarm,
          onAlarmStopped: _stopAlarm,
        ),
      ),
    );
  }

  void _ringAlarm() {
    setState(() {
      _alarmRinging = true; // Update state to indicate the alarm is ringing
    });

    // Show the alarm dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alarm Ringing!'),
        content: Text('Do you really want to get up?'),
        actions: [
          TextButton(
            child: Text('5 more minutes'),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
              _negotiateTime(5); // Add 5 more minutes
            },
          ),
          TextButton(
            child: Text('I\'ll get up now'),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
              _stopAlarm();
            },
          ),
        ],
      ),
    );
  }

  void _negotiateTime(int additionalMinutes) {
    _flutterLocalNotificationsPlugin.cancel(0); // Cancel the previous alarm
    _ringAlarm(); // Show the alarm dialog again

    // Schedule a new alarm after additional minutes
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime newScheduledDate = now.add(Duration(minutes: additionalMinutes));

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'alarm_channel_id',
      'Alarm Notifications',
      channelDescription: 'This channel is used for alarm notifications.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('clockalarm1'), // Default sound
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Alarm',
      'Time to wake up again!',
      newScheduledDate,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _stopAlarm() {
    _flutterLocalNotificationsPlugin.cancel(0); // Stop the alarm notification
    setState(() {
      _alarmRinging = false; // Update state to indicate the alarm is stopped
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alarm stopped!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Negotiation Alarm App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _alarmRinging ? 'Alarm is ringing!' : 'Set an alarm',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _setAlarm(context),
              child: Text('Set Alarm'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _stopAlarm,
              child: Text('Stop Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}
