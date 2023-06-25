import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_application/services/theme_services.dart';
import 'package:todo_application/ui/pages/notification_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.brush_sharp,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            ThemeServices().switchTheme();
            Get.to(
                const NotificationScreen(payload: 'payload|payload|payload'));
          },
        ),
        backgroundColor: context.theme.colorScheme.background,
      ),
      body: Container(),
    );
  }
}
