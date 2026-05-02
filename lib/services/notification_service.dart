import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/reminder.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings);

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> scheduleReminder(Reminder reminder) async {
    final scheduledDate = tz.TZDateTime.from(reminder.dateTime, tz.local);

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    const androidDetails = AndroidNotificationDetails(
      'remindu_channel',
      'Remindu Reminders',
      channelDescription: 'Your curated reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const details = NotificationDetails(android: androidDetails);

    final id = reminder.id.hashCode.abs() % 2147483647;

    switch (reminder.repeatType) {
      case RepeatType.once:
        await _plugin.zonedSchedule(
          id,
          'Remindu',
          reminder.title,
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
        break;

      case RepeatType.daily:
        await _plugin.zonedSchedule(
          id,
          'Remindu',
          reminder.title,
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
        break;

      case RepeatType.weekly:
        await _plugin.zonedSchedule(
          id,
          'Remindu',
          reminder.title,
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
        break;

      case RepeatType.monthly:
        await _plugin.zonedSchedule(
          id,
          'Remindu',
          reminder.title,
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
        );
        break;

      case RepeatType.yearly:
        await _plugin.zonedSchedule(
          id,
          'Remindu',
          reminder.title,
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
        break;
    }
  }

  static Future<void> cancelReminder(String id) async {
    await _plugin.cancel(id.hashCode.abs() % 2147483647);
  }
}