import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/models/task.dart';

import '../db/db_helper.dart';

class TaskController extends GetxController {
  RxList<Task> tasksList = <Task>[].obs;
  static String _selectedDate = DateFormat.yMMMEd().format(DateTime.now());

  getTasks({selectedDate = ''}) async {
    if (selectedDate != '') _selectedDate = selectedDate;
    final List<Map<String, dynamic>> tasks = await DBHelper.query();

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
    tasksList.removeWhere((element) =>
        !isWeekly(element) &&
        !isMonthly(element) &&
        element.repeat != 'Daily' &&
        element.date != _selectedDate);
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

  bool isMonthly(Task element) {
    if (element.repeat != 'Monthly') return false;

    return element.date!.split(',')[1].split(' ')[2] ==
        _selectedDate.split(',')[1].split(' ')[2];
  }

  bool isWeekly(Task element) {
    if (element.repeat != 'Weekly') return false;

    return element.date!.split(',')[0] == _selectedDate.split(',')[0];
  }
}
