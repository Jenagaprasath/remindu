import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder.dart';

class StorageService {
  static const _key = 'remindu_reminders';

  static Future<List<Reminder>> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    return jsonList.map((e) => Reminder.fromJson(e)).toList();
  }

  static Future<void> saveReminders(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(reminders.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonStr);
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
    final reminders = await loadReminders();
    final now = DateTime.now();
    reminders.removeWhere((r) =>
        r.repeatType == RepeatType.once && r.dateTime.isBefore(now));
    await saveReminders(reminders);
  }
}