import 'package:flutter/material.dart';

class Medicine {
  int? id;
  String? title;
  String? note;
  String? startDate;
  String? endDate;
  String? startTime;
  Color? color;
  int? remind;
  String? repeat;
  int? numOfShots;
  int? totalNumOfShots;
  Medicine(
      {required this.id,
      required this.title,
      required this.note,
      required this.startDate,
      required this.endDate,
      required this.startTime,
      required this.color,
      required this.remind,
      required this.repeat,
      required this.numOfShots,
      this.totalNumOfShots});
}
