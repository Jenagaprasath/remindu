import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder.dart';

class StorageService {
  static const _key = 'remindu_reminders';

  static Future<List<Reminder>> loadReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final jsonStr = prefs.getString(_key);
      if (jsonStr == null || jsonStr.isEmpty) return [];
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      final reminders = jsonList
          .map((e) {
            try {
              return Reminder.fromJson(e);
            } catch (_) {
              return null;
            }
          })
          .whereType<Reminder>()
          .toList();
      return reminders;
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveReminders(List<Reminder> reminders) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr =
          jsonEncode(reminders.map((e) => e.toJson()).toList());
      await prefs.setString(_key, jsonStr);
    } catch (e) {
      // silent fail
    }
  }

  static Future<void> addReminder(Reminder reminder) async {
    final reminders = await loadReminders();
    reminders.add(reminder);
    await saveReminders(reminders);
  }

  static Future<void> deleteReminder(String id) async {
    final reminders = await loadReminders();
    reminders.removeWhere((r) => r.id == id);
    await saveReminders(reminders);
  }

  static Future<void> deleteExpiredOnceReminders() async {
    try {
      final reminders = await loadReminders();
      final now = DateTime.now();
      reminders.removeWhere((r) =>
          r.repeatType == RepeatType.once &&
          r.dateTime.isBefore(now));
      await saveReminders(reminders);
    } catch (e) {
      // silent fail
    }
  }
}