import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/models/task.dart';

import '../db/db_helper.dart';

class TaskController with ChangeNotifier {
  List<Task> tasksList = [];
  static String _selectedDate = DateFormat.yMMMEd().format(DateTime.now());
  bool isFinished = false;

  getTasks({selectedDate = ''}) async {
    if (selectedDate != '') _selectedDate = selectedDate;
    final List<Map<String, dynamic>> tasks =
        await DBHelper.query(DBHelper.tasksTableName);

    tasksList = [];
    notifyListeners();

    tasksList.assignAll(tasks
        .map((e) => Task(
            id: e['id'],
            title: e['title'],
            note: e['note'],
            isCompleted: e['isCompleted'],
            date: e['date'],
            startTime: e['startTime'],
            endTime: e['endTime'],
            color: Color(e['color']),
            remind: e['remind'],
            repeat: e['repeat']))
        .toList());
    tasksList.removeWhere(
        (element) => !isRepeating(element) && element.date != _selectedDate);
    isFinished = true;
    notifyListeners();
  }

  addTask(Task task) async {
    await DBHelper.insert(DBHelper.tasksTableName, task: task);
    print(task.date);
    getTasks();
  }

  deleteTask(int id) async {
    await DBHelper.delete(DBHelper.tasksTableName, id);
    getTasks();
  }

  updateTask(int id) async {
    await DBHelper.update(DBHelper.tasksTableName, id);
    getTasks();
  }

  bool isRepeating(element) {
    var selectedDate = toDate(_selectedDate);
    var formattedDate = toDate(element.date!);

    if (selectedDate.isBefore(formattedDate)) {
      return false;
    }
    if (element.repeat == 'None')
      return false;
    else if (element.repeat == 'Weekly') {
      return element.date!.split(',')[0] == _selectedDate.split(',')[0];
    } else if (element.repeat == 'Monthly') {
      return element.date!.split(',')[1].split(' ')[2] ==
          _selectedDate.split(',')[1].split(' ')[2];
    } else {
      return true;
    }
  }

  DateTime toDate(stringDate) {
    String year = stringDate.split(',')[2];
    String month = stringDate.split(',')[1].split(' ')[1];
    String day = stringDate.split(',')[1].split(' ')[2];
    var dateString = month + ' ' + day + ',' + year;

    DateFormat format = DateFormat('MMM dd, yyyy');
    return format.parse(dateString);
  }
}

/*class TaskController extends GetxController {
  RxList<Task> tasksList = <Task>[].obs;
  static String _selectedDate = DateFormat.yMMMEd().format(DateTime.now());
  RxBool isFinished = false.obs;

  getTasks({selectedDate = ''}) async {
    if (selectedDate != '') _selectedDate = selectedDate;
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    print(tasks.length);

    tasksList.clear();
    tasksList.assignAll(tasks
        .map((e) => Task(
            id: e['id'],
            title: e['title'],
            note: e['note'],
            isCompleted: e['isCompleted'],
            date: e['date'],
            startTime: e['startTime'],
            endTime: e['endTime'],
            color: Color(e['color']),
            remind: e['remind'],
            repeat: e['repeat']))
        .toList());
    tasksList.removeWhere(
        (element) => !isRepeating(element) && element.date != _selectedDate);
    isFinished = true.obs;
    print(tasksList.length);
  }

  addTask(Task task) async {
    await DBHelper.insert(task);
    print(task.date);
    getTasks();
  }

  deleteTask(int id) async {
    await DBHelper.delete(id);
    getTasks();
  }

  updateTask(int id) async {
    await DBHelper.update(id);
  }

  bool isRepeating(element) {
    var selectedDate = toDate(_selectedDate);
    var formattedDate = toDate(element.date!);

    if (selectedDate.isBefore(formattedDate)) {
      return false;
    }
    if (element.repeat == 'None')
      return false;
    else if (element.repeat == 'Weekly') {
      return element.date!.split(',')[0] == _selectedDate.split(',')[0];
    } else if (element.repeat == 'Monthly') {
      return element.date!.split(',')[1].split(' ')[2] ==
          _selectedDate.split(',')[1].split(' ')[2];
    } else {
      return true;
    }
  }

  DateTime toDate(stringDate) {
    String year = stringDate.split(',')[2];
    String month = stringDate.split(',')[1].split(' ')[1];
    String day = stringDate.split(',')[1].split(' ')[2];
    var dateString = month + ' ' + day + ',' + year;

    DateFormat format = DateFormat('MMM dd, yyyy');
    return format.parse(dateString);
  }
}*/
