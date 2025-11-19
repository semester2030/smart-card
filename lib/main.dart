import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'providers/auth_provider.dart';
import 'providers/visitor_provider.dart';
import 'providers/exhibitor_provider.dart';
import 'providers/theme_provider.dart';
import 'services/local_storage_service.dart';
import 'services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Timezone
  tz.initializeTimeZones();
  
  // Initialize Local Storage
  await LocalStorageService.init();
  
  // Initialize Notifications
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  runApp(const SmartCardApp());
}

class SmartCardApp extends StatelessWidget {
  const SmartCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VisitorProvider()),
        ChangeNotifierProvider(create: (_) => ExhibitorProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'سمارت كارد',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: Routes.splash,
            routes: Routes.routes,
          );
        },
      ),
    );
  }
}
