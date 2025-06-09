import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotiService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Future<void> initNotifiaction() async {
  //   if (_isInitialized) return;

  //   const initSettingsAndriod = AndroidInitializationSettings(
  //     '@mipmap/ic_launcher',
  //   );
  //   const initSettings = InitializationSettings(android: initSettingsAndriod);

  //   await notificationPlugin.initialize(initSettings);
  //   tz.initializeTimeZones();

  // }

  Future<void> initNotifiaction() async {
    if (_isInitialized) return;

    const initSettingsAndriod = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: initSettingsAndriod);
    await notificationPlugin.initialize(initSettings);
    tz.initializeTimeZones();
    _isInitialized = true; // ✅ Important: mark initialized
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily notification',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String? title,
    required String? body,
    required DateTime scheduledTime,
  }) async {
    final scheduledTZ = tz.TZDateTime.from(scheduledTime, tz.local);
    print("Scheduled at: $scheduledTZ | Now: ${DateTime.now()}");

    await notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTZ,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'your_payload', // optional
      matchDateTimeComponents: null,
    );
  }

  Future<void> cancelNotification(int id) async {
    await notificationPlugin.cancel(id);
  }
}
