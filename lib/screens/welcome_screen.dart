import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky/screens/main_screen.dart';
import '../app_themes/app_themes.dart';
import '../core/widgets/custom_text_form_field.dart';
import '../service/username_shared_preferences_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final nameFieldKey = GlobalKey<CustomTextFieldState>();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = isDark ? AppThemes.darkColors : AppThemes.lightColors;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/Vector.svg",
                    height: 42.h,
                    width: 42.w,
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    "Tasky",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 108.h),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome To Tasky",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colors.text,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        SvgPicture.asset(
                          "assets/images/wave.svg",
                          height: 28.h,
                          width: 28.w,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Your productivity journey starts here.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SvgPicture.asset(
                      "assets/images/pana.svg",
                      height: 199,
                      width: 215,
                    ),
                    SizedBox(height: 28.h),
                    CustomTextField(
                      controller: _usernameController,
                      key: nameFieldKey,
                      label: "Full Name",
                      hint: "e.g. Sarah Khalid",
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                        ),
                        onPressed: () async {
                          if (nameFieldKey.currentState!.validate()) {
                            await UserPreferences.saveUsername(
                              _usernameController.text,
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainScreen(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Let's Get Started",
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontFamily: "Poppins",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
