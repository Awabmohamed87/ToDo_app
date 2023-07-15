import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
import 'package:todo_application/ui/widgets/task_tile.dart';

import '../../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = TaskController();
  DateTime _selectedDate = DateTime.now();
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestAndroidPermission();
    notifyHelper.initializeNotification();
    _taskController.getTasks(
        selectedDate: DateFormat.yMd().format(_selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    _taskController.getTasks(
        selectedDate: DateFormat.yMd().format(_selectedDate));
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(),
      body: Column(
        children: [
          _createTaskBar(),
          _createDateBar(),
          const SizedBox(height: 8),
          _showTasks(),
        ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
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
                _taskController.getTasks(
                    selectedDate: DateFormat.yMd().format(_selectedDate));
              }),
        ],
      ),
    );
  }

  Widget _createDateBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: _selectedDate,
        height: 100,
        selectionColor: MyTheme.primaryClr,
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
            _taskController.getTasks(
                selectedDate: DateFormat.yMd().format(_selectedDate));
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
      ),
    );
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: SizeConfig.orientation == Orientation.landscape
            ? task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8
            : task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.25
                : SizeConfig.screenHeight * 0.35,
        color: Get.isDarkMode ? MyTheme.darkHeaderClr : Colors.white,
        child: Column(children: [
          Flexible(
              child: Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
            ),
          )),
          task.isCompleted == 0
              ? _buildBottomSheet(
                  label: 'Mark as completed',
                  onTap: () {
                    setState(() {
                      _taskController.updateTask(task.id!);
                      Get.back();
                    });
                  },
                  clr: MyTheme.primaryClr)
              : Container(),
          _buildBottomSheet(
            label: 'Delete',
            onTap: () {
              setState(() {
                _taskController.deleteTask(task.id!);
                Get.back();
              });
            },
            clr: MyTheme.primaryClr,
          ),
          Divider(
            color: Get.isDarkMode ? Colors.grey : MyTheme.darkGreyClr,
          ),
          _buildBottomSheet(
            label: 'Cancel',
            onTap: () {
              Get.back();
            },
            clr: MyTheme.primaryClr,
          ),
          const SizedBox(height: 20),
        ]),
      ),
    ));
  }

  Widget _showTasks() {
    return _taskController.tasksList.toList().isEmpty
        ? _noTasksMsg()
        : Expanded(
            child: Obx(
            () => ListView.builder(
              scrollDirection: SizeConfig.orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal,
              itemBuilder: ((context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    horizontalOffset: 300,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        child: TaskTile(
                            task: _taskController.tasksList.toList()[index]),
                        onTap: () {
                          setState(() {
                            _showBottomSheet(context,
                                _taskController.tasksList.toList()[index]);
                          });
                        },
                      ),
                    ),
                  ),
                );
              }),
              itemCount: _taskController.tasksList.toList().length,
            ),
          ));
  }

  Widget _noTasksMsg() {
    return Stack(children: [
      AnimatedPositioned(
        duration: const Duration(seconds: 3),
        child: RefreshIndicator(
          onRefresh: () async {
            _taskController.getTasks();
          },
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
      ),
    ]);
  }
}
