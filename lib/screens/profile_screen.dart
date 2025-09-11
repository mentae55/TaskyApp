import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/screens/user_details.dart';
import 'package:tasky/screens/welcome_screen.dart';
import 'package:tasky/service/task_hive_service.dart';
import '../core/controllers/provider/theme_manger_provider.dart';
import '../service/username_shared_preferences_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        bottomOpacity: 64.h,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("My Profile", style: theme.textTheme.titleMedium),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 85.r,
                        backgroundImage: AssetImage('assets/images/me.png'),
                      ),
                      Positioned(
                        bottom: 0.h,
                        right: 0.h,
                        child: Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/camera.svg',
                            color: isDark ? Colors.grey[400] : Colors.black,
                            width: 18.w,
                            height: 18.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    username,

                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: 20.sp),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    bio,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: 14.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile Info",
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontSize: 20.sp,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 10.h),

                SizedBox(
                  width: double.infinity.w,
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
                            fontSize: 16.sp,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_rounded),
                      ),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 0.6,
                        indent: 16,
                        endIndent: 16,
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: double.infinity.w,
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
                            fontSize: 16.sp,
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
                        color: Colors.grey[300],
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
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Confirm Logout",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: isDark
                                        ? Colors.grey[100]
                                        : Colors.black,
                                  ),
                                ),
                                content: Text(
                                  "Are you sure you want to log out?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    // Cancel
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    // Confirm
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirm == true) {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.clear();
                            await TaskHiveService().resetDatabase();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WelcomeScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        leading: SvgPicture.asset(
                          'assets/images/logout.svg',
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        title: Text(
                          "Log Out",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_rounded),
                      ),

                      Divider(
                        color: Colors.grey[300],
                        thickness: 0.6,
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
