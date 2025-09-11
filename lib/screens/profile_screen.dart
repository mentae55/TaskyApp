import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/controllers/provider/theme_manger_provider.dart';
import 'package:tasky/screens/user_detalis.dart';
import 'package:tasky/screens/welcome_screen.dart';
import '../service/task_sql_service.dart';
import '../service/username_shared_preferences_service.dart';
import 'main_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "User";
  String bio = "No bio added yet";

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final savedUsername = await UserPreferences.getUsername();
    final savedBio = await UserPreferences.getBio();
    setState(() {
      username = savedUsername ?? "User";
      bio = savedBio?.isNotEmpty == true ? savedBio! : "No bio added yet";
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 64,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
              (route) => false,
            );
          },
        ),
        title: Text("My Profile", style: theme.textTheme.titleMedium),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 85,
                        backgroundImage: AssetImage('assets/images/me.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/camera.svg',
                            color: isDark ? Colors.white : Colors.black,
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    username,

                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    bio,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile Info",
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontSize: 20,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserDetailsScreen(),
                            ),
                          );
                          if (result == true) {
                            _loadUserDetails();
                          }
                        },
                        leading: SvgPicture.asset(
                          'assets/images/profile.svg',
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        title: Text(
                          "User Details",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_rounded),
                      ),
                      Divider(
                        color: Colors.grey[700],
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      ListTile(
                        leading: SvgPicture.asset(
                          'assets/images/moon.svg',
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        title: Text(
                          "Dark Mode",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        trailing: Switch(
                          value:
                              Provider.of<ThemeManager>(context).themeMode ==
                              ThemeMode.dark,
                          onChanged: (value) {
                            Provider.of<ThemeManager>(
                              context,
                              listen: false,
                            ).toggleTheme();
                          },
                          activeColor: isDark
                              ? Colors.white
                              : theme.colorScheme.onPrimary,
                          activeTrackColor: theme.primaryColor,
                          inactiveThumbColor: isDark
                              ? Colors.grey
                              : Colors.grey[400],
                          inactiveTrackColor: isDark
                              ? Colors.white24
                              : Colors.grey[300],
                        ),
                      ),
                      Divider(
                        color: Colors.grey[700],
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear();
                          await TaskSqlService().resetDatabase();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WelcomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        leading: SvgPicture.asset(
                          'assets/images/logout.svg',
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        title: Text(
                          "Log Out",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_rounded),
                      ),
                      Divider(
                        color: Colors.grey[700],
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
