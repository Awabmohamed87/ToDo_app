import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/controllers/task_controller.dart';
import 'package:todo_application/db/db_helper.dart';
import 'package:todo_application/services/theme_services.dart';
import 'package:todo_application/ui/pages/alarm_screen.dart';
import 'package:todo_application/ui/theme.dart';

import 'ui/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB();
  await GetStorage.init();
  await Alarm.init(showDebugLogs: true);
  Alarm.ringStream.stream.listen((alarmsettings) {
    Get.to(() => AlarmScreen(id: alarmsettings.id));
  });
  runApp(ChangeNotifierProvider(
      create: (context) => TaskController(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: MyTheme.light,
      darkTheme: MyTheme.dark,
      themeMode: ThemeServices().theme,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
