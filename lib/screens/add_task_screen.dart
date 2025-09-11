import 'package:flutter/material.dart';
import '../core/task_class/task_for_hive.dart';
import '../core/widgets/custom_text_form_field.dart';
import '../service/task_hive_service.dart';
import 'main_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isHighPriority = false;
  final TaskHiveService _dbService = TaskHiveService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text("New Task", style: theme.textTheme.titleMedium),
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomTextField(
              label: "Task Name",
              hint: "Finish UI design for login screen",
              controller: _titleController,
            ),
            SizedBox(height: 20.h),
            CustomTextField(
              label: "Task Description",
              hint: "Finish onboarding UI and hand off to devs by Thursday.",
              height: 160.h,
              controller: _descController,
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(
                  "High Priority",
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 20.sp),
                ),
                const Spacer(),
                Switch(
                  value: _isHighPriority,
                  onChanged: (value) {
                    setState(() {
                      _isHighPriority = value;
                    });
                  },
                  activeColor: isDark
                      ? Colors.white
                      : theme.colorScheme.onPrimary,
                  activeTrackColor: theme.primaryColor,
                  inactiveThumbColor: isDark ? Colors.grey : Colors.grey[400],
                  inactiveTrackColor: isDark
                      ? Colors.white24
                      : Colors.grey[300],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.h),
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty) {
                final task = Task(
                  title: _titleController.text,
                  description: _descController.text,
                  isHighPriority: _isHighPriority,
                );
                await _dbService.insertTask(task);
                Navigator.pop(context, true);
              }
            },
            child: Text(
              "+ Add Task",
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
