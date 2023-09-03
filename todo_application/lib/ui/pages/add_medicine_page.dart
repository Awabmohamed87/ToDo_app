import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/controllers/medicine_controller.dart';
import 'package:todo_application/models/medicine.dart';
import 'package:todo_application/ui/theme.dart';
import 'package:todo_application/ui/widgets/button.dart';
import 'package:todo_application/ui/widgets/input_field.dart';

class AddMedicinePage extends StatefulWidget {
  final DateTime selectedDate;
  const AddMedicinePage(this.selectedDate, {Key? key}) : super(key: key);

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final MedicineController medicineController = Get.put(MedicineController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  Color pickerColor = Colors.grey[400]!;
  late DateTime _startDate;
  late DateTime _endDate;

  String _startTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 1)))
      .toString();

  int _selectedRemind = 0;
  List<int> remindList = [0, 5, 10, 15, 20, 25, 30];
  String _selectedRepeat = 'Every 24 hours';
  List<String> repeatList = [
    'Every 24 hours',
    'Every 12 hours',
    'Every 8 hours',
    'Every 6 hours'
  ];

  int _selectedColorIndex = 0;
  Color? _selectedColor = MyTheme.colors[0];
  @override
  void initState() {
    _startDate = widget.selectedDate;
    _endDate = _startDate.add(const Duration(days: 7));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Add Medicine',
              textAlign: TextAlign.center,
              style: headingStyle,
            ),
            const SizedBox(height: 10),
            InputField(
                label: 'Medicine Name',
                note: 'Enter title here..',
                controller: _titleController),
            InputField(
                label: 'Note',
                note: 'Enter note here..(optional)',
                controller: _noteController),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InputField(
                    child: IconButton(
                      onPressed: () {
                        _getDateFromUser(isStartDate: true);
                      },
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    label: 'Start Date',
                    note: DateFormat.yMd().format(_startDate),
                  ),
                ),
                Expanded(
                  child: InputField(
                    child: IconButton(
                      onPressed: () {
                        _getDateFromUser(isStartDate: false);
                      },
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    label: 'End Date',
                    note: DateFormat.yMd().format(_endDate),
                  ),
                ),
              ],
            ),
            InputField(
              label: 'Start Time',
              note: _startTime,
              child: IconButton(
                onPressed: () {
                  _getTimeFromUser();
                },
                icon: const Icon(
                  Icons.access_time_outlined,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
            ),
            InputField(
              label: 'Repeat',
              note: _selectedRepeat,
              child: DropdownButton(
                icon: const Icon(Icons.keyboard_arrow_down),
                iconSize: 32,
                underline: Container(height: 0),
                style: subTitleStyle,
                borderRadius: BorderRadius.circular(10),
                onChanged: (val) {
                  setState(() {
                    _selectedRepeat = val!;
                  });
                },
                items: repeatList
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
              ),
            ),
            InputField(
                label: 'Remind',
                note: _selectedRemind.toString() + ' minutes early..',
                child: DropdownButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconSize: 32,
                  underline: Container(height: 0),
                  style: subTitleStyle,
                  borderRadius: BorderRadius.circular(10),
                  onChanged: (val) {
                    setState(() {
                      _selectedRemind = val!;
                    });
                  },
                  items: remindList
                      .map((e) => DropdownMenuItem(
                            child: Text('$e'),
                            value: e,
                          ))
                      .toList(),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Color',
                        style: titleStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          createColorButton(0),
                          createColorButton(1),
                          createColorButton(2),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                        title: const Text('Pick a color!'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              ColorPicker(
                                                pickerColor: pickerColor,
                                                onColorChanged: (newColor) {
                                                  setState(() {
                                                    pickerColor = newColor;
                                                  });
                                                  MyTheme.colors
                                                      .add(pickerColor);
                                                  _selectedColor = pickerColor;
                                                },
                                              ),
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(ctx).pop(),
                                                  child: const Text('Save'))
                                            ],
                                          ),
                                        )));
                                setState(() {
                                  _selectedColorIndex = 3;
                                });
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                child: _selectedColorIndex == 3
                                    ? const Icon(
                                        Icons.done,
                                        size: 24,
                                        color: Colors.white,
                                        weight: 1200,
                                      )
                                    : const Center(
                                        child: Text(
                                          '...',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                decoration: BoxDecoration(
                                    color: pickerColor,
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  MyButton(
                      label: 'Add Medicine',
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        _checkStartTime();
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: context.theme.colorScheme.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.grey,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/person.jpeg'),
          radius: 15,
        ),
        SizedBox(width: 10),
      ],
    );
  }

  createColorButton(index) => Padding(
        padding: const EdgeInsets.only(right: 5),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedColorIndex = index;
            });
            _selectedColor = MyTheme.colors[_selectedColorIndex];
          },
          child: Container(
            width: 30,
            height: 30,
            child: _selectedColorIndex == index
                ? const Icon(
                    Icons.done,
                    size: 24,
                    color: Colors.white,
                    weight: 1200,
                  )
                : Container(),
            decoration: BoxDecoration(
                color: MyTheme.colors[index],
                borderRadius: BorderRadius.circular(50)),
          ),
        ),
      );

  createSnackBox(title, content) {
    return Get.snackbar(
      title,
      content,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      icon: const Icon(Icons.warning),
      colorText: MyTheme.pinkClr,
    );
  }

  void _getTimeFromUser() async {
    TimeOfDay? _pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            DateTime.now().add(const Duration(minutes: 1))));

    setState(() {
      if (_pickedTime != null) {
        _startTime = _pickedTime.format(context).toString();
      }
    });
  }

  void _getDateFromUser({required bool isStartDate}) async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100));
    setState(() {
      if (isStartDate) {
        if (_pickedDate != null) _startDate = _pickedDate;
      } else {
        if (_pickedDate != null) _endDate = _pickedDate;
      }
    });
  }

  DateTime getNextPillTime(DateTime date, int numOfShots) {
    int shotsPerDay = 0;
    if (_selectedRepeat == 'Every 24 hours') {
      shotsPerDay = 1;
    } else if (_selectedRepeat == 'Every 12 hours') {
      shotsPerDay = 2;
    } else if (_selectedRepeat == 'Every 8 hours') {
      shotsPerDay = 3;
    } else {
      shotsPerDay = 4;
    }

    date = date.add(Duration(hours: 24 ~/ shotsPerDay));

    return date;
  }

  int _getNumOfPills(DateTime medDte) {
    int num = 0;
    while (medDte.isBefore(DateTime.now())) {
      medDte = getNextPillTime(medDte, num);
      num++;
      print(medDte.toString());
    }
    return num;
  }

  DateTime _toDate(stringDate, String time) {
    String year = stringDate.split(',')[2];
    String month = stringDate.split(',')[1].split(' ')[1];
    String day = stringDate.split(',')[1].split(' ')[2];
    var dateString = month + ' ' + day + ',' + year + ' ' + time;

    DateFormat format = DateFormat('MMM dd, yyyy hh:mm a');
    return format.parse(dateString);
  }

  _checkStartTime() {
    final DateTime medDate =
        _toDate(DateFormat.yMMMEd().format(_startDate), _startTime);
    if (DateTime.now().isAfter(medDate)) {
      int missedPills = _getNumOfPills(medDate);
      Get.dialog(AlertDialog(
        content: Text(
            'There is $missedPills pill/s date are passed have you taken them?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _validateData(numOfShotsTaken: missedPills);
              },
              child: const Text('Yes')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                createSnackBox('Warning', 'Change the time to a coming one');
              },
              child: const Text('No!')),
        ],
      ));
    } else {
      _validateData();
    }
  }

  _validateData({numOfShotsTaken = 0}) async {
    if (_titleController.text.isEmpty) {
      createSnackBox('Required!!', "Title can't be empty");
      return;
    }

    Medicine medicine = Medicine(
        id: 0,
        title: _titleController.text,
        note: _noteController.text,
        startDate: DateFormat.yMMMEd().format(_startDate),
        endDate: DateFormat.yMMMEd().format(_endDate),
        startTime: _startTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        numOfShots: numOfShotsTaken);
    await medicineController.addMedicine(medicine);

    Get.back();
  }
}
