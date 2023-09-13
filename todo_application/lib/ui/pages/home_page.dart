import 'dart:async';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/controllers/medicine_controller.dart';
import 'package:todo_application/controllers/task_controller.dart';
import 'package:todo_application/services/image_services.dart';
import 'package:todo_application/services/name_services.dart';
import 'package:todo_application/services/notification_services.dart';
import 'package:todo_application/services/theme_services.dart';
import 'package:todo_application/ui/pages/add_medicine_page.dart';
import 'package:todo_application/ui/pages/add_task_page.dart';
import 'package:todo_application/ui/size_config.dart';
import 'package:todo_application/ui/theme.dart';
import 'package:todo_application/ui/widgets/button.dart';
import 'package:todo_application/ui/widgets/task_tile.dart';
import 'package:todo_application/ui/widgets/medicine_tile.dart';

import '../../models/medicine.dart';
import '../../models/task.dart';
import '../../services/alarm_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  late NotifyHelper notifyHelper;
  bool isPressed = false;
  final _image = 'assets/images/person.jpeg';
  final ImagePicker picker = ImagePicker();
  // ignore: prefer_typing_uninitialized_variables
  var newImage;
  final TextEditingController _controller = TextEditingController();
  int _selectedIndex = 0;
  final MedicineController _medicineController = MedicineController();

  Timer? _remiainingMedicineTimeTimer;

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
  void dispose() {
    print('dispose');
    if (_remiainingMedicineTimeTimer != null)
      _remiainingMedicineTimeTimer!.cancel();
    super.dispose();
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
          _selectedIndex == 0 ? _showTasks() : _showMedicines()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: (newIndex) {
          setState(() {
            _selectedIndex = newIndex;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.background,
        selectedItemColor: MyTheme.primaryClr,
        unselectedItemColor: Colors.grey[700],
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.featured_play_list_outlined), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/pills-bottle.png',
                color:
                    _selectedIndex == 0 ? Colors.grey[700] : MyTheme.primaryClr,
                width: 30,
                height: 30,
              ),
              label: 'Medicines')
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
            setState(() {
              _controller.text = NameServices().name;
            });
            Get.bottomSheet(StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) stateSetter) {
                return SingleChildScrollView(
                  child: Container(
                    color:
                        Get.isDarkMode ? MyTheme.darkHeaderClr : Colors.white,
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
                        const SizedBox(height: 10),
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
                                          borderRadius:
                                              BorderRadius.circular(20)),
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
                                    final pickedImageFile =
                                        await picker.pickImage(
                                            source: newItem == 1
                                                ? ImageSource.camera
                                                : ImageSource.gallery,
                                            imageQuality: 100);
                                    if (pickedImageFile != null) {
                                      stateSetter(() {
                                        newImage = File(pickedImageFile.path);
                                      });
                                      setState(() {
                                        newImage = File(pickedImageFile.path);
                                      });
                                      ImageServices()
                                          .saveThemeToBox(pickedImageFile.path);
                                    }
                                    // Navigator.of(context).pop();
                                  }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.screenWidth * 0.25),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    labelStyle: holderStyle,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.screenWidth * 0.03),
                                    labelText: 'Name',
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Get.isDarkMode
                                                ? Colors.white60
                                                : Colors.grey[600]!)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              InkWell(
                                onTap: () {
                                  NameServices().setName(_controller.text);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                child: Icon(
                                  Icons.save_outlined,
                                  color: Colors.grey[600],
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10)
                      ],
                    ),
                  ),
                );
              },
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
              label: _selectedIndex == 0 ? '+ Add Task' : '+ Add Medicine',
              onTap: _selectedIndex == 0
                  ? () async {
                      await Get.to(() => AddTaskPage(_selectedDate));
                      Provider.of<TaskController>(context, listen: false)
                          .getTasks(
                              selectedDate:
                                  DateFormat.yMMMEd().format(_selectedDate));
                    }
                  : () async {
                      await Get.to(() => AddMedicinePage(_selectedDate));
                      _medicineController.getMedicines(
                          selectedDate:
                              DateFormat.yMMMEd().format(_selectedDate));
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
                notifyHelper.isScheduled(task.id).then((value) {
                  if (!value) {
                    var hour = task.startTime.toString().split(':')[0];
                    var minutes =
                        task.startTime.toString().split(':')[1].split(' ')[0];
                    var tmp =
                        task.startTime.toString().split(':')[1].split(' ')[1];
                    notifyHelper.scheduledNotification(
                        tmp == 'AM' ? int.parse(hour) : int.parse(hour) + 12,
                        int.parse(minutes),
                        task);
                  }
                });

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
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: SizeConfig.orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            children: [
              SizeConfig.orientation == Orientation.landscape
                  ? const SizedBox(height: 0)
                  : const SizedBox(height: 170),
              SvgPicture.asset(
                'assets/images/task.svg',
                // ignore: deprecated_member_use
                color: MyTheme.primaryClr.withOpacity(0.5),
                height:
                    SizeConfig.orientation == Orientation.portrait ? 90 : 65,
              ),
              Text(
                "You don't have any tasks yet! \n Add new tasks to make ur days productive",
                style: subTitleStyle,
                textAlign: TextAlign.center,
              ),
              SizeConfig.orientation == Orientation.landscape
                  ? const SizedBox(height: 0)
                  : const SizedBox(height: 170),
            ],
          ),
        ),
      ),
    ]);
  }

  _showMedicines() {
    _medicineController.getMedicines(
        selectedDate: DateFormat.yMMMEd().format(_selectedDate));
    return Obx(() => _medicineController.medicineList.toList().isEmpty
        ? _noMedMsg()
        : Expanded(
            child: ListView.builder(
              itemCount: _medicineController.medicineList.toList().length,
              scrollDirection: SizeConfig.orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal,
              itemBuilder: ((context, index) {
                var med = _medicineController.medicineList.toList()[index];
                AlarmServices.setAlarm(med);

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 300),
                  child: SlideAnimation(
                    horizontalOffset: 300,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        child: MedicineTile(medicine: med),
                        onTap: () {
                          if (_remiainingMedicineTimeTimer != null)
                            _remiainingMedicineTimeTimer!.cancel();
                          setState(() {
                            _showStatefulBottomSheet(context, med);
                          });
                        },
                      ),
                    ),
                  ),
                );
              }),
            ),
          ));
  }

  _noMedMsg() {
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
                    : const SizedBox(height: 150),
                SvgPicture.asset(
                  'assets/images/positive-thinking.svg',

                  // ignore: deprecated_member_use
                  color: MyTheme.primaryClr.withOpacity(0.5),
                  height:
                      SizeConfig.orientation == Orientation.portrait ? 130 : 65,
                ),
                Text(
                  "You don't have scheduled pills today \n Hope u stay always well",
                  style: subTitleStyle,
                  textAlign: TextAlign.center,
                ),
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(height: 0)
                    : const SizedBox(height: 170),
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  void _showStatefulBottomSheet(BuildContext context, Medicine medicine) {
    Get.bottomSheet(
      StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) stateSetter) {
          String time = Alarm.getAlarm(medicine.id!) == null
              ? ''
              : _printDuration(Alarm.getAlarm(medicine.id!)!
                  .dateTime
                  .difference(DateTime.now()));
          if (Alarm.getAlarm(medicine.id!) != null) {
            if (medicine.numOfShots! < medicine.totalNumOfShots!) {
              _remiainingMedicineTimeTimer =
                  Timer(const Duration(seconds: 1), () {
                if (Get.isBottomSheetOpen!) {
                  stateSetter(() {
                    if (medicine.numOfShots! < medicine.totalNumOfShots!) {
                      time = Alarm.getAlarm(medicine.id!) == null
                          ? ''
                          : Alarm.getAlarm(medicine.id!)!
                              .dateTime
                              .difference(DateTime.now())
                              .toString();
                    }
                  });
                }
              });
            }
          }

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 4),
              width: SizeConfig.screenWidth,
              height: SizeConfig.orientation == Orientation.landscape
                  ? SizeConfig.screenHeight * 0.8
                  : medicine.numOfShots == medicine.totalNumOfShots
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
                        color: Get.isDarkMode
                            ? Colors.grey[600]
                            : Colors.grey[300],
                      ),
                    ),
                  ),
                  if (medicine.numOfShots != medicine.totalNumOfShots)
                    _buildBottomSheet(
                        label: Alarm.getAlarm(medicine.id!) != null
                            ? 'Time remaining $time'
                            : 'Mark as Taken',
                        onTap: () {
                          if (medicine.numOfShots == medicine.totalNumOfShots)
                            return;
                          if (Alarm.getAlarm(medicine.id!) == null) {
                            setState(() {
                              _medicineController.updateMedicine(
                                  medicine.id!, medicine.numOfShots! + 1);
                              medicine.numOfShots = medicine.numOfShots! + 1;
                              Get.back();
                            });
                            AlarmServices.setAlarm(medicine);
                            Get.snackbar('',
                                'Next pill scheduled at ${Alarm.getAlarm(medicine.id!)!.dateTime.toLocal()}',
                                duration: const Duration(seconds: 5),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.white,
                                icon: const Icon(Icons.done),
                                colorText: MyTheme.primaryClr,
                                padding: const EdgeInsets.all(8));
                          }
                        },
                        clr: MyTheme.primaryClr),
                  _buildBottomSheet(
                    label: 'Delete',
                    onTap: () {
                      setState(() {
                        _medicineController.deleteMedicine(medicine.id!);
                        Get.back();
                      });
                      Alarm.stopAll();
                    },
                    clr: Colors.red[300]!,
                  ),
                  Divider(
                    color: Get.isDarkMode ? Colors.grey : MyTheme.darkGreyClr,
                  ),
                  _buildBottomSheet(
                    label: 'Cancel',
                    onTap: () {
                      _remiainingMedicineTimeTimer!.cancel();
                      Get.back();
                    },
                    clr: MyTheme.primaryClr,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
