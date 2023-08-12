import 'package:flutter/material.dart';

class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  Color? color;
  int? remind;
  String? repeat;
  Task(
      {required this.id,
      required this.title,
      required this.note,
      required this.isCompleted,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.color,
      required this.remind,
      required this.repeat});
}
