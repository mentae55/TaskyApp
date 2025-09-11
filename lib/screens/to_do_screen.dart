import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tasky/service/task_hive_service.dart';
import '../core/task_class/task_for_hive.dart';
import '../core/widgets/custom_task.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  List<Task> uncompletedTasks = [];
  bool isLoading = false;
  final TaskHiveService _dbService = TaskHiveService();

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
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
                      size: 80.r,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Great job!",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
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
                  SizedBox(height: 16.h),
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
                          SizedBox(height: 12.h),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
