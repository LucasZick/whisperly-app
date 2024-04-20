import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisperly/app_theme.dart';
import 'package:whisperly/firebase_options.dart';
import 'package:whisperly/services/auth_service.dart';
import 'package:whisperly/services/configs_service.dart';
import 'package:whisperly/routes.dart';
import 'package:whisperly/utils/app_routes.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WhisperlyApp());
}

class WhisperlyApp extends StatelessWidget {
  const WhisperlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ListenableProvider<ConfigsService>(create: (_) => ConfigsService())
      ],
      child: Consumer<ConfigsService>(
        builder: (ctx, notifier, child) {
          return MaterialApp(
            title: 'Whisperly',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
            initialRoute: AppRoutes.openingScreen,
            routes: routes,
          );
        },
      ),
    );
  }
}
