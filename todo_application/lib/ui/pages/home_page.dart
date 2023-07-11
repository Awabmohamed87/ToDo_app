import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/controllers/task_controller.dart';
import 'package:todo_application/services/notification_services.dart';
import 'package:todo_application/services/theme_services.dart';
import 'package:todo_application/ui/pages/add_task_page.dart';
import 'package:todo_application/ui/size_config.dart';
import 'package:todo_application/ui/theme.dart';
import 'package:todo_application/ui/widgets/button.dart';

import '../../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskController _taskController = TaskController();
  DateTime _selectedDate = DateTime.now();
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestAndroidPermission();
    notifyHelper.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _createTaskBar(),
              _createDateBar(),
              const SizedBox(height: 8),
              _showTasks(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: context.theme.colorScheme.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight,
          color: Get.isDarkMode ? Colors.white : MyTheme.darkGreyClr,
        ),
        onPressed: () {
          ThemeServices().switchTheme();

          notifyHelper.displayNotification(
              title: 'Notification', body: 'This is your first notification');
          //Get.to(const NotificationScreen(payload: 'payload|payload|payload'));
        },
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 15,
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _createTaskBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd('en_US').format(_selectedDate).toString(),
              style: subHeadingStyle,
            ),
            Text(
                DateFormat.E().format(_selectedDate) ==
                        DateFormat.E().format(DateTime.now())
                    ? 'Today'
                    : DateFormat.E().format(_selectedDate),
                style: headingStyle),
          ],
        ),
        MyButton(
            label: '+ Add Task',
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTasks();
            }),
      ],
    );
  }

  Widget _createDateBar() {
    return DatePicker(
      DateTime.now(),
      initialSelectedDate: _selectedDate,
      height: 100,
      selectionColor: MyTheme.primaryClr,
      onDateChange: (newDate) {
        setState(() {
          _selectedDate = newDate;
        });
      },
      dayTextStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      dateTextStyle: const TextStyle(
          color: Colors.grey, fontSize: 25, fontWeight: FontWeight.bold),
      monthTextStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _showTasks() {
    return Stack(children: [
      AnimatedPositioned(
        duration: const Duration(seconds: 3),
        child: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: SizeConfig.orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            children: [
              SizeConfig.orientation == Orientation.landscape
                  ? const SizedBox(height: 6)
                  : const SizedBox(height: 200),
              SvgPicture.asset(
                'images/task.svg',
                // ignore: deprecated_member_use
                color: MyTheme.primaryClr.withOpacity(0.5),
                height: 90,
              ),
              Text(
                "You don't have any tasks yet! \n Add new tasks to make ur days productive",
                style: subTitleStyle,
                textAlign: TextAlign.center,
              ),
              SizeConfig.orientation == Orientation.landscape
                  ? const SizedBox(height: 120)
                  : const SizedBox(height: 180),
            ],
          ),
        ),
      ),
    ]);
    /*Obx(
      () {
        if (_taskController.tasksList.isEmpty) {
          return Text(
            "Ypu don't have any tasks yet! \n Add new tasks to make ur days productive",
            style: subTitleStyle,
            textAlign: TextAlign.center,
          );
        } else
          return Container();
      },
    ));*/
  }
}
