import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:old_man_do/models/app_state.dart';
import 'package:old_man_do/theme/app_theme.dart';
import 'package:old_man_do/screens/home_screen.dart';
import 'package:old_man_do/screens/snacks_screen.dart';
import 'package:old_man_do/screens/tracker_screen.dart';
import 'package:old_man_do/screens/analytics_screen.dart';
import 'package:old_man_do/screens/field_manual_screen.dart';
import 'package:old_man_do/services/background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MaterialApp(
        title: 'Old Man Do',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/snacks': (context) => const SnacksScreen(),
          '/tracker': (context) => const TrackerScreen(),
          '/analytics': (context) => const AnalyticsScreen(),
          '/manual': (context) => const FieldManualScreen(),
        },
      ),
    );
  }
}
