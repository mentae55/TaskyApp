import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/screens/splash_screen.dart';
import 'app_themes/app_themes.dart';
import 'controllers/provider/theme_manger_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeManager(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeManager.themeMode,
      home: SplashScreen(),
    );
  }
}
