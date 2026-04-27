import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/reminder_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
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