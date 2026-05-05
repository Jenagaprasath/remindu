import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/reminder.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    try {
      tz.initializeTimeZones();

      const AndroidInitializationSettings android =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings settings =
          InitializationSettings(android: android);

      await _plugin.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
      );

      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          _plugin.resolvePlatformSpecificImplementation
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        await androidPlugin.requestNotificationsPermission();
        await androidPlugin.requestExactAlarmsPermission();
      }

      // Create high priority notification channel
      await _createNotificationChannel();
    } catch (e) {
      // silent fail
    }
  }

  static Future<void> _createNotificationChannel() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          _plugin.resolvePlatformSpecificImplementation
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        const AndroidNotificationChannel channel =
            AndroidNotificationChannel(
          'remindu_alarm_channel',
          'Remindu Alarms',
          description: 'Full screen alarm notifications for Remindu',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        );
        await androidPlugin.createNotificationChannel(channel);
      }
    } catch (e) {
      // silent fail
    }
  }

  @pragma('vm:entry-point')
  static void _onNotificationTap(NotificationResponse response) {
    // Handled in main.dart
  }

  static Future<void> scheduleReminder(Reminder reminder) async {
    try {
      final tz.TZDateTime scheduledDate =
          tz.TZDateTime.from(reminder.dateTime, tz.local);

      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

      final int id = reminder.id.hashCode.abs() % 2147483647;

      // Full screen intent details
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'remindu_alarm_channel',
        'Remindu Alarms',
        channelDescription: 'Full screen alarm notifications',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        autoCancel: false,
        ongoing: false,
        styleInformation: BigTextStyleInformation(
          reminder.notes?.isNotEmpty == true
              ? reminder.notes!
              : 'Tap to view your reminder',
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
            '⏰ ${reminder.title}',
            reminder.notes?.isNotEmpty == true
                ? reminder.notes!
                : 'Tap to view your reminder',
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
            '⏰ ${reminder.title}',
            reminder.notes?.isNotEmpty == true
                ? reminder.notes!
                : 'Tap to view your reminder',
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
            '⏰ ${reminder.title}',
            reminder.notes?.isNotEmpty == true
                ? reminder.notes!
                : 'Tap to view your reminder',
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
            '⏰ ${reminder.title}',
            reminder.notes?.isNotEmpty == true
                ? reminder.notes!
                : 'Tap to view your reminder',
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
            '⏰ ${reminder.title}',
            reminder.notes?.isNotEmpty == true
                ? reminder.notes!
                : 'Tap to view your reminder',
            scheduledDate,
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
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