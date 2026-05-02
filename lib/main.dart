import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';
import 'screens/reminder_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  try {
    await NotificationService.init();
  } catch (e) {
    // silent fail
  }

  try {
    await StorageService.deleteExpiredOnceReminders();
  } catch (e) {
    // silent fail
  }

  runApp(const ReminduApp());
}

class ReminduApp extends StatelessWidget {
  const ReminduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remindu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const ReminderListScreen(),
    );
  }
}