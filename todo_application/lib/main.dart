import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_application/services/theme_services.dart';
import 'package:todo_application/ui/theme.dart';

import 'ui/pages/home_page.dart';

void main() async {
  runApp(const MyApp());
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
