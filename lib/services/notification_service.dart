import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/reminder.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    try {
      tz.initializeTimeZones();

      final String localTimezone =
          await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTimezone));

      const AndroidInitializationSettings android =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings settings =
          InitializationSettings(android: android);

      await _plugin.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
      );
    } catch (e) {
      // silent fail
    }
  }

  @pragma('vm:entry-point')
  static void _onNotificationTap(NotificationResponse response) {
    // handled in main.dart
  }

  static Future<void> scheduleReminder(Reminder reminder) async {
    try {
      final String localTimezone =
          await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTimezone));

      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        reminder.dateTime.year,
        reminder.dateTime.month,
        reminder.dateTime.day,
        reminder.dateTime.hour,
        reminder.dateTime.minute,
        0,
      );

      if (scheduledDate.isBefore(now)) {
        if (reminder.repeatType == RepeatType.once) return;
      }

      final int id = reminder.id.hashCode.abs() % 2147483647;

      final Int64List vibrationPattern =
          Int64List.fromList([0, 500, 200, 500]);

      final String body =
          reminder.notes != null && reminder.notes!.isNotEmpty
              ? reminder.notes!
              : 'Tap to view your reminder';

      final String title = '⏰ ${reminder.title}';

      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'remindu_alarm_channel',
        'Remindu Alarms',
        channelDescription: 'Full screen alarm notifications',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        vibrationPattern: vibrationPattern,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        autoCancel: true,
        styleInformation: BigTextStyleInformation(
          body,
          contentTitle: reminder.title,
          summaryText: reminder.repeatLabel,
        ),
      );

      final NotificationDetails details =
          NotificationDetails(android: androidDetails);

      switch (reminder.repeatType) {
        case RepeatType.once:
          await _plugin.zonedSchedule(
            id,
            title,
            body,
            scheduledDate,
            details,
            androidScheduleMode:
                AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
          break;

        case RepeatType.daily:
          await _plugin.zonedSchedule(
            id,
            title,
            body,
            scheduledDate,
            details,
            androidScheduleMode:
                AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time,
          );
          break;

        case RepeatType.weekly:
          await _plugin.zonedSchedule(
            id,
            title,
            body,
            scheduledDate,
            details,
            androidScheduleMode:
                AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents:
                DateTimeComponents.dayOfWeekAndTime,
          );
          break;

        case RepeatType.monthly:
          await _plugin.zonedSchedule(
            id,
            title,
            body,
            scheduledDate,
            details,
            androidScheduleMode:
                AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents:
                DateTimeComponents.dayOfMonthAndTime,
          );
          break;

        case RepeatType.yearly:
          await _plugin.zonedSchedule(
            id,
            title,
            body,
            scheduledDate,
            details,
            androidScheduleMode:
                AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dateAndTime,
          );
          break;
      }
    } catch (e) {
      // silent fail
    }
  }

  static Future<void> cancelReminder(String id) async {
    try {
      await _plugin.cancel(id.hashCode.abs() % 2147483647);
    } catch (e) {
      // silent fail
    }
  }

  static Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (e) {
      // silent fail
    }
  }
}