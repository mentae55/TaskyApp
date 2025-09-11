import 'package:flutter/material.dart';
import 'package:tasky/service/task_hive_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../task_class/task_for_hive.dart';

class HighPriorityTasksCard extends StatelessWidget {
  final List<Task> tasks;
  final Future<void> Function(Task) onToggle;

  const HighPriorityTasksCard({
    super.key,
    required this.tasks,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final highPriorityTasks = tasks
        .where((task) => task.isHighPriority)
        .toList();

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "High Priority Tasks",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              if (highPriorityTasks.isEmpty)
                Text(
                  "No high priority tasks!",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: highPriorityTasks.length,
                  itemBuilder: (context, index) {
                    final task = highPriorityTasks[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 4.h),
                      child: Row(
                        children: [
                          Checkbox(
                            value: task.isDone,
                            onChanged: (value) async {
                              if (value == null) return;
                              final updated = task.copyWith(isDone: value);
                              await TaskHiveService().updateTask(updated);
                              await onToggle(updated);
                            },
                            activeColor: Theme.of(context).primaryColor,
                            side: BorderSide(
                              color: task.isDone
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: task.isDone
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.onSurface,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
