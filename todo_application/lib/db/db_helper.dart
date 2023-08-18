import 'package:sqflite/sqflite.dart';

import '../models/medicine.dart';
import '../models/task.dart';

class DBHelper {
  static const int _version = 1;
  static const String tasksTableName = 'TASKS';
  static const String medicinesTableName = 'MEDS';
  static Database? _db;

  static Future<void> initDB() async {
    if (_db == null) {
      try {
        String _path = getDatabasesPath().toString() + 'local_task_db.db';
        // open the database
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE $tasksTableName (id INTEGER PRIMARY KEY AUTOINCREMENT,'
              'title TEXT, note TEXT,'
              'color INTEGER, isCompleted INTEGER, remind INTEGER,'
              ' date TEXT, startTime TEXT, endTime TEXT, repeat TEXT)');
          await db.execute(
              'CREATE TABLE $medicinesTableName (id INTEGER PRIMARY KEY AUTOINCREMENT,'
              'title TEXT, note TEXT,'
              'color INTEGER, numOfShots INTEGER,'
              ' startDate TEXT,endDate TEXT, startTime TEXT, repeat int, remind int)');
        });
      } catch (e) {
        rethrow;
      }
    }
  }

  static Future<int> insert(String table,
      {Task? task, Medicine? medicine}) async {
    // Insert some records in a transaction
    if (table == tasksTableName) {
      return await _db!.insert(table, {
        'title': task!.title,
        'note': task.note,
        'color': task.color!.value,
        'isCompleted': task.isCompleted,
        'remind': task.remind,
        'date': task.date,
        'startTime': task.startTime,
        'endTime': task.endTime,
        'repeat': task.repeat
      });
    } else {
      return await _db!.insert(table, {
        'title': medicine!.title,
        'note': medicine.note,
        'color': medicine.color!.value,
        'remind': medicine.remind,
        'startDate': medicine.startDate,
        'endDate': medicine.endDate,
        'startTime': medicine.startTime,
        'repeat': medicine.repeat,
        'numOfShots': medicine.numOfShots
      });
    }
  }

  static Future<int> delete(table, int id) async {
    return await _db!.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> empty(String table) async {
    return await _db!.rawDelete('DELETE FROM $table');
  }

  static Future<int> update(table, int id, {int? numOfShots}) async {
    if (table == tasksTableName)
      return await _db!.rawUpdate(
          '''
    UPDATE $table 
    SET isCompleted = ?
    WHERE id = ?
    ''',
          [1, id]);
    else {
      return await _db!.rawUpdate(
          '''
    UPDATE $table 
    SET numOfShots = ?
    WHERE id = ?
    ''',
          [numOfShots, id]);
    }
  }

  static Future<List<Map<String, dynamic>>> query(table) async {
    return await _db!.query(
      table,
    );
  }
}
