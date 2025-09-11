import 'package:flutter/material.dart';
import '../../task_class/task_for_sql.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  String _username = '';

  List<Task> get tasks => _tasks;

  String get username => _username;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void setUsername(String name) {
    _username = name;
    notifyListeners();
  }
}
