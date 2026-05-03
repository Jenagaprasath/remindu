import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/reminder.dart';

class StorageService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'remindu.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reminders (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            dateTime TEXT NOT NULL,
            repeatType INTEGER NOT NULL,
            isCompleted INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  static Future<List<Reminder>> loadReminders() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps =
          await db.query('reminders', orderBy: 'dateTime ASC');
      return maps.map((e) => Reminder.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> addReminder(Reminder reminder) async {
    try {
      final db = await database;
      await db.insert(
        'reminders',
        reminder.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // silent fail
    }
  }

  static Future<void> saveReminders(List<Reminder> reminders) async {
    try {
      final db = await database;
      final batch = db.batch();
      batch.delete('reminders');
      for (final r in reminders) {
        batch.insert('reminders', r.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    } catch (e) {
      // silent fail
    }
  }

  static Future<void> updateReminder(Reminder reminder) async {
    try {
      final db = await database;
      await db.update(
        'reminders',
        reminder.toJson(),
        where: 'id = ?',
        whereArgs: [reminder.id],
      );
    } catch (e) {
      // silent fail
    }
  }

  static Future<void> deleteReminder(String id) async {
    try {
      final db = await database;
      await db.delete(
        'reminders',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      // silent fail
    }
  }

  static Future<void> deleteExpiredOnceReminders() async {
    try {
      final db = await database;
      final now = DateTime.now().toIso8601String();
      await db.delete(
        'reminders',
        where: 'repeatType = ? AND dateTime < ?',
        whereArgs: [RepeatType.once.index, now],
      );
    } catch (e) {
      // silent fail
    }
  }
}