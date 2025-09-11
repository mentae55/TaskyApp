import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../core/task_class/task_for_hive.dart';

class TaskHiveService {
  static const String _boxName = 'tasks';
  static Box<Task>? _taskBox;
  static int _nextId = 1;

  static final TaskHiveService _taskService = TaskHiveService._();

  TaskHiveService._();

  factory TaskHiveService() => _taskService;

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }
  }

  Future<Box<Task>> get _box async {
    if (_taskBox != null && _taskBox!.isOpen) {
      return _taskBox!;
    }
    _taskBox = await Hive.openBox<Task>(_boxName);
    await _initializeNextId();
    return _taskBox!;
  }

  // Initialize the next ID counter
  Future<void> _initializeNextId() async {
    final box = _taskBox!;
    if (box.isEmpty) {
      _nextId = 1;
    } else {
      final maxId = box.values
          .where((task) => task.id != null)
          .map((task) => task.id!)
          .fold<int>(0, (max, id) => id > max ? id : max);
      _nextId = maxId + 1;
    }
  }

  // Insert a new task
  Future<int> insertTask(Task task) async {
    final box = await _box;

    task.id ??= _nextId++;

    await box.put(task.id, task);
    return task.id!;
  }

  Future<List<Task>> getTasks() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<int> updateTask(Task task) async {
    final box = await _box;
    if (task.id != null && box.containsKey(task.id)) {
      await box.put(task.id, task);
      return 1;
    }
    return 0;
  }

  // Delete a task by ID
  Future<int> deleteTask(int id) async {
    final box = await _box;
    if (box.containsKey(id)) {
      await box.delete(id);
      return 1;
    }
    return 0;
  }

  Future<void> clearTasks() async {
    final box = await _box;
    await box.clear();
    _nextId = 1;
  }

  Future<List<Task>> getSelectedTasks() async {
    final box = await _box;
    return box.values.where((task) => task.isDone).toList();
  }

  Future<List<Task>> getUnselectedTasks() async {
    final box = await _box;
    return box.values.where((task) => !task.isDone).toList();
  }

  Future<void> resetDatabase() async {
    if (_taskBox != null && _taskBox!.isOpen) {
      await _taskBox!.close();
    }
    await Hive.deleteBoxFromDisk(_boxName);
    _taskBox = null;
    _nextId = 1;
  }

  Future<void> closeBox() async {
    if (_taskBox != null && _taskBox!.isOpen) {
      await _taskBox!.close();
      _taskBox = null;
    }
  }

  bool isBoxOpen() {
    return _taskBox != null && _taskBox!.isOpen;
  }

  Future<Task?> getTaskById(int id) async {
    final box = await _box;
    return box.get(id);
  }

  Future<List<Task>> getHighPriorityTasks() async {
    final box = await _box;
    return box.values.where((task) => task.isHighPriority).toList();
  }

  Future<int> getTasksCount() async {
    final box = await _box;
    return box.length;
  }

  Future<int> getCompletedTasksCount() async {
    final box = await _box;
    return box.values.where((task) => task.isDone).length;
  }
}
