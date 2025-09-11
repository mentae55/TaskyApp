import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/screens/main_screen.dart';
import 'package:tasky/screens/welcome_screen.dart';
import '../controllers/provider/theme_manger_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _checkUserAndNavigate();
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => WelcomeScreen()),
      );
    }
  }

  Future<void> _checkUserAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    await Future.delayed(const Duration(milliseconds: 1500));
    if (username != null && username.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final theme = themeManager.currentTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              gradient: RadialGradient(
                colors: [theme.colorScheme.primary, Colors.transparent],
                radius: 1,
                center: Alignment.topLeft,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [theme.colorScheme.primary, Colors.transparent],
                      radius: 1,
                      center: Alignment.bottomRight,
                    ),
                  ),
                ),
                const Center(child: SplashLogo()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SvgPicture.asset(
      "assets/images/Vector.svg",
      width: 87,
      height: 87,
      colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
    );
  }
}
