import 'package:get/get.dart';
import 'package:todo_application/models/task.dart';

import '../db/db_helper.dart';

class TaskController extends GetxController {
  RxList<Task> tasksList = <Task>[].obs;
  var _selectedDate;

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
            color: e['color'],
            remind: e['remind'],
            repeat: e['repeat']))
        .toList());
    tasksList.removeWhere((element) => element.date != _selectedDate);
  }

  addTask(Task task) async {
    await DBHelper.insert(task);
    getTasks();
  }

  deleteTask(int id) async {
    await DBHelper.delete(id);
    getTasks();
  }

  updateTask(int id) async {
    await DBHelper.update(id);
  }
}
