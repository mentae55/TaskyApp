import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/task.dart';

class TaskSqlService {
  static Database? _db;
  static const _dbName = 'tasky.db';
  static const _dbVersion = 1;
  static const tableTask = 'tasky';

  static final TaskSqlService _taskDatabase = TaskSqlService._();

  TaskSqlService._();

  factory TaskSqlService() => _taskDatabase;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<bool> isTableExists() async {
    final db = await database;
    try {
      await db.rawQuery('SELECT 1 FROM $tableTask LIMIT 1');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableTask(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT,
          isDone INTEGER NOT NULL DEFAULT 0,
          isHighPriority INTEGER NOT NULL DEFAULT 0
        );
      ''');
      },
    );
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(
      tableTask,
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final tableExists = await isTableExists();
    if (!tableExists) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableTask(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isDone INTEGER NOT NULL DEFAULT 0,
        isHighPriority INTEGER NOT NULL DEFAULT 0
      );
    ''');
    }

    final rows = await db.query(tableTask);
    return rows.map((e) => Task.fromJson(e)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return db.update(
      tableTask,
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(tableTask, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearTasks() async {
    final db = await database;
    await db.delete(tableTask);
  }

  Future<List<Task>> getSelectedTasks() async {
    final db = await database;
    final rows = await db.query(tableTask, where: 'isDone=?', whereArgs: [1]);
    return rows.map((e) => Task.fromJson(e)).toList();
  }

  Future<List<Task>> getUnselectedTasks() async {
    final db = await database;
    final rows = await db.query(tableTask, where: 'isDone=?', whereArgs: [0]);
    return rows.map((e) => Task.fromJson(e)).toList();
  }

  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, _dbName);
    await deleteDatabase(path);
    _db = await _initDB();
  }
}
