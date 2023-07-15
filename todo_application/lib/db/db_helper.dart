import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static const int _version = 1;
  static const String _tableName = 'TASKS';
  static Database? _db;

  static Future<void> initDB() async {
    if (_db == null) {
      try {
        String _path = getDatabasesPath().toString() + 'local_task_db.db';
        print(_path);
        // open the database
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT,'
              'title TEXT, note TEXT,'
              'color INTEGER, isCompleted INTEGER, remind INTEGER,'
              ' date TEXT, startTime TEXT, endTime TEXT, repeat TEXT)');
        });
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(Task task) async {
    print('inside insert');
    // Insert some records in a transaction
    return await _db!.insert(_tableName, {
      'title': task.title,
      'note': task.note,
      'color': task.color,
      'isCompleted': task.isCompleted,
      'remind': task.remind,
      'date': task.date,
      'startTime': task.startTime,
      'endTime': task.endTime,
      'repeat': task.repeat
    });
  }

  static Future<int> delete(int id) async {
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> update(int id) async {
    return await _db!.rawUpdate('''
    UPDATE $_tableName 
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(
      _tableName,
    );
  }
}
