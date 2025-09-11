import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/task_class/task_for_hive.dart';
import '../core/widgets/custom_task.dart';
import '../service/task_hive_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  List<Task> completedTasks = [];
  bool isLoading = false;
  final TaskHiveService _dbService = TaskHiveService();

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
        automaticallyImplyLeading: false,
        centerTitle: true,
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
                      size: 80.r,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "No completed tasks yet",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
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
                  SizedBox(height: 16.h),
                  Expanded(
                    child: ListView.separated(
                      itemCount: completedTasks.length,
                      itemBuilder: (context, index) {
                        final task = completedTasks[index];
                        return CustomTask(
                          task: task,
                          onToggle: (_) => _toggleTask(task),
                          onDelete: (deletedTask) {
                            setState(() {
                              completedTasks.removeWhere(
                                (task) => task.id == deletedTask.id,
                              );
                            });
                          },
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
