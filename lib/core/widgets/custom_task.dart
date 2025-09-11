import 'package:flutter/material.dart';
import '../task_class/task_for_hive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTask extends StatefulWidget {
  final Task task;
  final Function(Task) onToggle;
  final Function(Task)? onDelete;

  const CustomTask({
    super.key,
    required this.task,
    required this.onToggle,
    this.onDelete,
  });

  @override
  State<CustomTask> createState() => _CustomTaskState();
}

class _CustomTaskState extends State<CustomTask> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.task.isDone;
  }

  void _toggleCheck() {
    setState(() {
      _isChecked = !_isChecked;
    });
    widget.onToggle(widget.task.copyWith(isDone: _isChecked));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ListTile(
        onTap: _toggleCheck,
        leading: Checkbox(
          value: _isChecked,
          onChanged: (value) => _toggleCheck(),
          activeColor: theme.primaryColor,
        ),
        title: Text(
          widget.task.title,
          style: TextStyle(
            fontSize: 18.sp,
            color: _isChecked
                ? (isDark ? const Color(0xFFA0A0A0) : Colors.grey[600])
                : theme.colorScheme.onSurface,
            decoration: _isChecked ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: widget.task.description.isNotEmpty
            ? Text(
                widget.task.description,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? Colors.grey : Colors.grey[600],
                ),
              )
            : null,
        trailing: PopupMenuButton<String>(
          color: theme.colorScheme.surface,
          onSelected: (value) async {
            if (value == 'delete') {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Confirm Delete",
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: isDark ? Colors.grey[100] : Colors.black,
                      ),
                    ),
                    content: Text("Are you sure you want to delete this task?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                await widget.task.delete();
                widget.onDelete?.call(widget.task);
              }
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                title: Text("Delete"),
                trailing: Icon(Icons.delete_outline, color: Colors.red),
              ),
            ),
          ],
          icon: Icon(Icons.more_vert_outlined, color: Colors.grey),
        ),
      ),
    );
  }
}
