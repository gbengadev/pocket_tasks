// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/task.dart';
import 'sql_statements.dart';

/// A class that handles all SQLite interactions for tasks
class TaskDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // Sets up the database and creates the tasks table
  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Tasks.db');

    return openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute(createTaskTableCommand);
    });
  }

  // Retrieves all tasks from the database
  static Future<List<Task>> getTasks() async {
    final db = await database;
    final result = await db.query('Tasks');
    return result.map((e) => Task.fromMap(e)).toList();
  }

  // Inserts a task and returns the inserted task with new ID
  static Future<void> addTask(Task task) async {
    final db = await database;
    await db.insert('Tasks', task.toMap());
  }

  // Updates a task in the database
  static Future<void> updateTask(Task task) async {
    final db = await database;
    await db
        .update('Tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  // Deletes a task from the database
  static Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete('Tasks', where: 'id = ?', whereArgs: [id]);
  }
}
