import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';
import 'screens/reminder_list_screen.dart';
import 'screens/notifying_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  navigatorKey.currentState?.push(
    MaterialPageRoute(
      builder: (_) => NotifyingScreen(
        title: response.payload ?? 'Reminder',
        notes: '',
      ),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await StorageService.database;

  try {
    await NotificationService.init();
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
      navigatorKey: navigatorKey,
      home: const ReminderListScreen(),
    );
  }
}