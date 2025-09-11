import 'package:flutter/material.dart';
import 'package:tasky/screens/main_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/service/username_shared_preferences_service.dart';
import '../core/widgets/custom_text_form_field.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final savedUsername = await UserPreferences.getUsername();
    final savedBio = await UserPreferences.getBio();
    setState(() {
      _nameController.text = savedUsername ?? "";
      _bioController.text = savedBio ?? "";
    });
  }

  Future<void> _saveUserDetails() async {
    if (_nameController.text.isNotEmpty) {
      await UserPreferences.saveUsername(_nameController.text);
      await UserPreferences.saveBio(_bioController.text);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
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
        title: Text("User Details", style: theme.textTheme.titleMedium),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomTextField(
              label: "User Name",
              hint: "Enter your name",
              controller: _nameController,
            ),
            SizedBox(height: 20.h),
            CustomTextField(
              label: "Motivation Quote",
              hint: "Write something about yourself...",
              height: 160.h,
              controller: _bioController,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: _saveUserDetails,
            child: Text(
              "Save Changes",
              style: theme.textTheme.titleMedium?.copyWith(
                fontFamily: "Poppins",
                fontSize: 14.sp,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
