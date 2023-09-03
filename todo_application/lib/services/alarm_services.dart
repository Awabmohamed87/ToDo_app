import 'package:alarm/alarm.dart';
import 'package:intl/intl.dart';

import '../models/medicine.dart';

class AlarmServices {
  static void setAlarm(Medicine med) async {
    var dateTime = _toDate(med.startDate, med.startTime!);

    var pillTime = getNextPillTime(med, dateTime);
    if (pillTime.isBefore(DateTime.now())) {
      return;
    }
    if (Alarm.getAlarm(med.id!) == null) {
      final alarmSettings = AlarmSettings(
          id: med.id!,
          dateTime: pillTime,
          assetAudioPath: 'assets/sound/alarm.mp3',
          loopAudio: true,
          vibrate: true,
          stopOnNotificationOpen: true);
      await Alarm.set(alarmSettings: alarmSettings);
    }
  }

  static DateTime _toDate(stringDate, String time) {
    String year = stringDate.split(',')[2];
    String month = stringDate.split(',')[1].split(' ')[1];
    String day = stringDate.split(',')[1].split(' ')[2];
    var dateString = month + ' ' + day + ',' + year + ' ' + time;

    DateFormat format = DateFormat('MMM dd, yyyy hh:mm a');
    return format.parse(dateString);
  }

  static DateTime getNextPillTime(Medicine med, DateTime date) {
    int shotsPerDay = 0;
    if (med.repeat == 'Every 24 hours') {
      shotsPerDay = 1;
    } else if (med.repeat == 'Every 12 hours') {
      shotsPerDay = 2;
    } else if (med.repeat == 'Every 8 hours') {
      shotsPerDay = 3;
    } else {
      shotsPerDay = 4;
    }
    date = date.add(Duration(days: med.numOfShots! ~/ shotsPerDay));

    date = date.add(Duration(
        hours: ((med.numOfShots! % shotsPerDay) * (24 / shotsPerDay)).toInt()));

    return date.subtract(Duration(minutes: med.remind!)).isAfter(DateTime.now())
        ? date.subtract(Duration(minutes: med.remind!))
        : date;
  }
}
