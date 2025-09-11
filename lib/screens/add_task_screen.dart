import 'package:flutter/material.dart';
import 'package:tasky/service/task_sql_service.dart';
import '../constants/task.dart';
import '../core/custom_text_form_field.dart';
import 'main_screen.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isHighPriority = false;
  final TaskSqlService _dbService = TaskSqlService();

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
            const SizedBox(height: 20),
            CustomTextField(
              label: "Task Description",
              hint: "Finish onboarding UI and hand off to devs by Thursday.",
              height: 160,
              controller: _descController,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "High Priority",
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 20),
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
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
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
                fontSize: 14,
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
