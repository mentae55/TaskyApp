import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../app_themes/app_themes.dart';
import '../core/custom_text_form_field.dart';
import '../service/username_shared_preferences_service.dart';
import 'home_screen.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/Vector.svg",
                    height: 42,
                    width: 42,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Tasky",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 108),
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
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          "assets/images/wave.svg",
                          height: 28,
                          width: 28,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Your productivity journey starts here.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SvgPicture.asset(
                      "assets/images/pana.svg",
                      height: 199,
                      width: 215,
                    ),
                    const SizedBox(height: 28),
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
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
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
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Let's Get Started",
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontFamily: "Poppins",
                            fontSize: 14,
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
