import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/task.dart';
import 'sql_statements.dart';

class TaskDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Tasks.db');

    return openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute(createTaskTableCommand);
    });
  }

  static Future<List<Task>> getTasks() async {
    final db = await database;
    final result = await db.query('Tasks');
    return result.map((e) => Task.fromMap(e)).toList();
  }

  static Future<void> addTask(Task Task) async {
    final db = await database;
    await db.insert('Tasks', Task.toMap());
  }

  static Future<void> updateTask(Task Task) async {
    final db = await database;
    await db
        .update('Tasks', Task.toMap(), where: 'id = ?', whereArgs: [Task.id]);
  }

  static Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete('Tasks', where: 'id = ?', whereArgs: [id]);
  }
}
