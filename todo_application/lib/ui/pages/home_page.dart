import 'dart:io';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/controllers/task_controller.dart';
import 'package:todo_application/services/image_services.dart';
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
  DateTime _selectedDate = DateTime.now();
  late NotifyHelper notifyHelper;
  bool isPressed = false;
  final _image = 'images/person.jpeg';
  final ImagePicker picker = ImagePicker();
  // ignore: prefer_typing_uninitialized_variables
  var newImage;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    if (Platform.isIOS)
      notifyHelper.requestIOSPermissions();
    else if (Platform.isAndroid) notifyHelper.requestAndroidPermission();
    notifyHelper.initializeNotification();
    if (ImageServices().profileImagePath != '')
      newImage = File(ImageServices().profileImagePath);
    Provider.of<TaskController>(context, listen: false)
        .getTasks(selectedDate: DateFormat.yMMMEd().format(_selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(),
      body: Column(
        children: [
          _createTaskBar(),
          _createDateBar(),
          const SizedBox(height: 8),
          _showTasks()
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
        },
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Get.bottomSheet(SingleChildScrollView(
              child: Container(
                color: Get.isDarkMode ? MyTheme.darkHeaderClr : Colors.white,
                padding: const EdgeInsets.only(top: 5),
                height: SizeConfig.screenHeight * 0.35,
                child: Column(
                  children: [
                    Flexible(
                      child: Container(
                        height: 6,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Get.isDarkMode
                              ? Colors.grey[600]
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Center(
                          child: buildCircleAvatar(
                              newImage == null
                                  ? AssetImage(_image)
                                  : FileImage(newImage),
                              SizeConfig.screenWidth * 0.2),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2(
                              iconStyleData: IconStyleData(
                                icon: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[350],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: const Icon(
                                    Icons.edit,
                                  ),
                                ),
                                iconSize: 25,
                                iconEnabledColor: Colors.black,
                              ),
                              alignment: Alignment.bottomRight,
                              items: const [
                                DropdownMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      Icon(Icons.camera_alt_outlined),
                                      SizedBox(width: 5),
                                      Text('Camera')
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(Icons
                                          .photo_size_select_actual_rounded),
                                      SizedBox(width: 5),
                                      Text('Gallery')
                                    ],
                                  ),
                                )
                              ],
                              onChanged: (newItem) async {
                                final pickedImageFile = await picker.pickImage(
                                    source: newItem == 1
                                        ? ImageSource.camera
                                        : ImageSource.gallery,
                                    imageQuality: 50,
                                    maxHeight: 300,
                                    maxWidth: 300);
                                if (pickedImageFile != null) {
                                  setState(() {
                                    newImage = File(pickedImageFile.path);
                                  });
                                  ImageServices()
                                      .saveThemeToBox(pickedImageFile.path);
                                }
                                Navigator.of(context).pop();
                              }),
                        ),
                        if (isPressed)
                          Container(
                            height: 20,
                            width: 20,
                            color: Colors.red,
                          )
                      ],
                    ),
                    const TextField(
                      decoration: InputDecoration(),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            ));
          },
          child: buildCircleAvatar(
              newImage == null ? AssetImage(_image) : FileImage(newImage),
              15.0),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  CircleAvatar buildCircleAvatar(image, radius) {
    return CircleAvatar(
      backgroundColor: Get.isDarkMode ? MyTheme.darkHeaderClr : Colors.white,
      backgroundImage: image,
      radius: radius,
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
                              DateFormat.E().format(DateTime.now()) &&
                          DateTime.now().day == _selectedDate.day &&
                          DateTime.now().month == _selectedDate.month &&
                          DateTime.now().year == _selectedDate.year
                      ? 'Today'
                      : DateFormat.E().format(_selectedDate),
                  style: headingStyle),
            ],
          ),
          MyButton(
              label: '+ Add Task',
              onTap: () async {
                await Get.to(() => AddTaskPage(_selectedDate));
                Provider.of<TaskController>(context, listen: false).getTasks(
                    selectedDate: DateFormat.yMMMEd().format(_selectedDate));
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
            Provider.of<TaskController>(context, listen: false).getTasks(
                selectedDate: DateFormat.yMMMEd().format(_selectedDate));
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
        child: Column(
          children: [
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
                        Provider.of<TaskController>(context, listen: false)
                            .updateTask(task.id!);
                        Get.back();
                      });
                    },
                    clr: MyTheme.primaryClr)
                : Container(),
            _buildBottomSheet(
              label: 'Delete',
              onTap: () {
                setState(() {
                  Provider.of<TaskController>(context, listen: false)
                      .deleteTask(task.id!);
                  Get.back();
                });
              },
              clr: Colors.red[300]!,
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
          ],
        ),
      ),
    ));
  }

  Widget _showTasks() {
    return Provider.of<TaskController>(context).tasksList.isEmpty
        ? _noTasksMsg()
        : Expanded(
            child: ListView.builder(
              itemCount: Provider.of<TaskController>(context).tasksList.length,
              scrollDirection: SizeConfig.orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal,
              itemBuilder: ((context, index) {
                final task =
                    Provider.of<TaskController>(context).tasksList[index];
                var hour = task.startTime.toString().split(':')[0];
                var minutes =
                    task.startTime.toString().split(':')[1].split(' ')[0];
                var tmp = task.startTime.toString().split(':')[1].split(' ')[1];
                notifyHelper.scheduledNotification(
                    tmp == 'AM' ? int.parse(hour) : int.parse(hour) + 12,
                    int.parse(minutes),
                    task);
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 300),
                  child: SlideAnimation(
                    horizontalOffset: 300,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        child: TaskTile(task: task),
                        onTap: () {
                          setState(() {
                            _showBottomSheet(context, task);
                          });
                        },
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
  }

  Widget _noTasksMsg() {
    return Stack(children: [
      AnimatedPositioned(
        duration: const Duration(seconds: 3),
        child: RefreshIndicator(
          onRefresh: () async {
            Provider.of<TaskController>(context, listen: false).getTasks();
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
