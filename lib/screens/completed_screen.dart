import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants/task.dart';
import '../service/task_sql_service.dart';
import '../core/custom_task.dart';
import 'main_screen.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  List<Task> completedTasks = [];
  bool isLoading = false;
  final TaskSqlService _dbService = TaskSqlService();

  @override
  void initState() {
    super.initState();
    _loadCompletedTasks();
  }

  Future<void> _loadCompletedTasks() async {
    setState(() => isLoading = true);
    try {
      final tasks = await _dbService.getSelectedTasks();
      setState(() {
        completedTasks = tasks;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (kDebugMode) {
        print('Error loading completed tasks: $e');
      }
    }
  }

  Future<void> _toggleTask(Task task) async {
    final updated = task.copyWith(isDone: !task.isDone);
    await _dbService.updateTask(updated);
    _loadCompletedTasks();
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
        title: Text("Completed Tasks", style: theme.textTheme.titleMedium),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : completedTasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No completed tasks yet",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Finish some tasks to see them here!",
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
                      itemCount: completedTasks.length,
                      itemBuilder: (context, index) {
                        final task = completedTasks[index];
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
