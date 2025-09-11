import 'package:flutter/material.dart';

import '../constants/task.dart';

class CustomTask extends StatefulWidget {
  final Task task;
  final Function(Task) onToggle;

  const CustomTask({super.key, required this.task, required this.onToggle});

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
        borderRadius: BorderRadius.circular(20),
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
            fontSize: 18,
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
                  fontSize: 13,
                  color: isDark ? Colors.grey : Colors.grey[600],
                ),
              )
            : null,
        trailing: Icon(Icons.more_vert_outlined, color: Colors.grey),
      ),
    );
  }
}
