import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../db/db_helper.dart';
import '../models/medicine.dart';

class MedicineController extends GetxController {
  RxList<Medicine> medicineList = <Medicine>[].obs;
  static String _selectedDate = DateFormat.yMMMEd().format(DateTime.now());

  getMedicines({selectedDate = ''}) async {
    if (selectedDate != '') _selectedDate = selectedDate;
    final List<Map<String, dynamic>> medicines =
        await DBHelper.query(DBHelper.medicinesTableName);

    medicineList.assignAll(medicines
        .map((e) => Medicine(
            numOfShots: e['numOfShots'],
            id: e['id'],
            title: e['title'],
            note: e['note'],
            startTime: e['startTime'],
            color: Color(e['color']),
            remind: e['remind'],
            repeat: e['repeat'],
            endDate: e['endDate'],
            startDate: e['startDate'],
            totalNumOfShots: calcTotalNumberOfShots(
                e['startDate'], e['endDate'], e['repeat'])))
        .toList());

    medicineList.removeWhere((element) =>
        !isRepeating(element) &&
        element.startDate != _selectedDate &&
        element.endDate != _selectedDate);
  }

  addMedicine(Medicine medicine) async {
    await DBHelper.insert(DBHelper.medicinesTableName, medicine: medicine);

    getMedicines();
  }

  deleteMedicine(int id) async {
    await DBHelper.delete(DBHelper.medicinesTableName, id);
    getMedicines();
  }

  updateMedicine(int id, int numOfShots) async {
    await DBHelper.update(DBHelper.medicinesTableName, id,
        numOfShots: numOfShots);
  }

  empty() async {
    await DBHelper.empty(DBHelper.medicinesTableName);
  }

  bool isRepeating(Medicine element) {
    var selectedDate = toDate(_selectedDate);
    var startDate = toDate(element.startDate);
    var endDate = toDate(element.endDate);
    if (startDate.isBefore(selectedDate) && endDate.isAfter(selectedDate))
      return true;

    return false;
  }

  getNextShotTime(Medicine medicine) {
    print(medicine.startTime);
  }

  DateTime toDate(stringDate) {
    String year = stringDate.split(',')[2];
    String month = stringDate.split(',')[1].split(' ')[1];
    String day = stringDate.split(',')[1].split(' ')[2];
    var dateString = month + ' ' + day + ',' + year;

    DateFormat format = DateFormat('MMM dd, yyyy');
    return format.parse(dateString);
  }

  calcTotalNumberOfShots(String startDate, endDate, repeat) {
    var start = toDate(startDate);
    var end = toDate(endDate);
    var diff = end.difference(start);

    if (repeat == 'Every 24 hours')
      return diff.inDays;
    else if (repeat == 'Every 12 hours')
      return diff.inDays * 2;
    else if (repeat == 'Every 8 hours')
      return diff.inDays * 3;
    else
      return diff.inDays * 4;
  }
}
