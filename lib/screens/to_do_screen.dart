import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants/task.dart';
import '../service/task_sql_service.dart';
import '../core/custom_task.dart';
import 'main_screen.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  List<Task> uncompletedTasks = [];
  bool isLoading = false;
  final TaskSqlService _dbService = TaskSqlService();

  @override
  void initState() {
    super.initState();
    _loadUncompletedTasks();
  }

  Future<void> _loadUncompletedTasks() async {
    setState(() => isLoading = true);
    try {
      final tasks = await _dbService.getUnselectedTasks();
      setState(() {
        uncompletedTasks = tasks;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (kDebugMode) {
        print('Error loading uncompleted tasks: $e');
      }
    }
  }

  Future<void> _toggleTask(Task task) async {
    final updated = task.copyWith(isDone: !task.isDone);
    await _dbService.updateTask(updated);
    _loadUncompletedTasks();
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
        title: Text("To Do Tasks", style: theme.textTheme.titleMedium),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : uncompletedTasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Great job!",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You've completed all your tasks!",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: uncompletedTasks.length,
                      itemBuilder: (context, index) {
                        final task = uncompletedTasks[index];
                        return CustomTask(
                          task: task,
                          onToggle: (_) => _toggleTask(task),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
