import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/controllers/task_controller.dart';
import 'package:todo_application/models/task.dart';
import 'package:todo_application/ui/theme.dart';
import 'package:todo_application/ui/widgets/button.dart';
import 'package:todo_application/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  final DateTime selectedDate;
  const AddTaskPage(this.selectedDate, {Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  Color pickerColor = Colors.grey[400]!;
  late DateTime _selectedDate;

  String _startTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 1)))
      .toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();

  int _selectedRemind = 0;
  List<int> remindList = [0, 5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int _selectedColorIndex = 0;
  Color? _selectedColor = MyTheme.colors[0];
  @override
  void initState() {
    _selectedDate = widget.selectedDate;
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
              'Add Task',
              textAlign: TextAlign.center,
              style: headingStyle,
            ),
            const SizedBox(height: 10),
            InputField(
                label: 'Title',
                note: 'Enter title here..',
                controller: _titleController),
            InputField(
                label: 'Note',
                note: 'Enter note here..',
                controller: _noteController),
            InputField(
              child: IconButton(
                onPressed: () {
                  _getDateFromUser();
                },
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                ),
              ),
              label: 'Date',
              note: DateFormat.yMd().format(_selectedDate),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: InputField(
                  label: 'Start Time',
                  note: _startTime,
                  child: IconButton(
                    onPressed: () {
                      _getTimeFromUser(isStartTime: true);
                    },
                    icon: const Icon(
                      Icons.access_time_outlined,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                )),
                Expanded(
                    child: InputField(
                  label: 'End Time',
                  note: _endTime,
                  child: IconButton(
                    onPressed: () {
                      _getTimeFromUser(isStartTime: false);
                    },
                    icon: const Icon(
                      Icons.access_time_outlined,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                )),
              ],
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
                                          child: ColorPicker(
                                            pickerColor: pickerColor,
                                            onColorChanged: (newColor) {
                                              setState(() {
                                                pickerColor = newColor;
                                              });
                                              MyTheme.colors.add(pickerColor);
                                              _selectedColor = pickerColor;
                                            },
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
                      label: 'Create Task',
                      onTap: () async {
                        _validateData();
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
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

  _validateData() async {
    if (_titleController.text.isEmpty) {
      createSnackBox('Required!!', "Title can't be empty");
      return;
    }
    if (_noteController.text.isEmpty) {
      createSnackBox('Required!!', "Note can't be empty");
      return;
    }
    Task task = Task(
        id: 0,
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMMMEd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat);

    await Provider.of<TaskController>(context, listen: false).addTask(task);
    Get.back();
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

  void _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            DateTime.now().add(const Duration(minutes: 1))));

    setState(() {
      if (_pickedTime != null) {
        if (isStartTime)
          _startTime = _pickedTime.format(context).toString();
        else
          _endTime = _pickedTime.format(context).toString();
      }
    });
  }

  void _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2100));
    setState(() {
      if (_pickedDate != null) _selectedDate = _pickedDate;
    });
  }
}
