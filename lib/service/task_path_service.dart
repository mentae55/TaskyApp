import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../core/task_class/task_for_sql.dart';

class TaskPathService {
  static const String tasksFileName = 'tasks.json';

  Future<File> _getTasksFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$tasksFileName');

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('[]');
    }

    return file;
  }

  Future<List<Task>> loadTasks() async {
    try {
      final file = await _getTasksFile();
      final contents = await file.readAsString();

      if (contents.trim().isEmpty) {
        await file.writeAsString('[]');
        return [];
      }

      final List<dynamic> jsonData = jsonDecode(contents);
      final tasks = jsonData
          .map((taskJson) => Task.fromJson(taskJson))
          .toList();

      if (kDebugMode) {
        print('Loaded ${tasks.length} tasks from file');
      }
      return tasks;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading tasks: $e');
      }

      final file = await _getTasksFile();
      await file.writeAsString('[]');
      return [];
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final file = await _getTasksFile();
      final jsonData = tasks.map((task) => task.toJson()).toList();
      final jsonString = jsonEncode(jsonData);

      await file.writeAsString(jsonString);
      if (kDebugMode) {
        print('Saved ${tasks.length} tasks to file: ${file.path}');
      }

      final savedContent = await file.readAsString();
      if (kDebugMode) {
        print('File content after save: $savedContent');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving tasks: $e');
      }
      rethrow;
    }
  }

  Future<void> clearTasks() async {
    try {
      final file = await _getTasksFile();
      await file.writeAsString('[]');
      if (kDebugMode) {
        print('Cleared all tasks');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing tasks: $e');
      }
    }
  }

  Future<String> getTasksFilePath() async {
    final file = await _getTasksFile();
    return file.path;
  }
}
