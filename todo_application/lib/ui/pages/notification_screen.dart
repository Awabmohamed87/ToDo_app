import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_application/ui/theme.dart';

import '../../services/name_services.dart';

class NotificationScreen extends StatefulWidget {
  final String payload;
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  Widget createElement({icon, text}) {
    return Row(
      children: [
        Icon(icon, size: 25, color: Colors.white),
        const SizedBox(width: 20),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 25),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: context.theme.colorScheme.background,
        title: Text(_payload.toString().split('|')[0], style: headingStyle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Column(
              children: [
                Text(
                  'Hi, ${NameServices().name}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color:
                          Get.isDarkMode ? Colors.white : MyTheme.darkGreyClr),
                ),
                const SizedBox(height: 10),
                Text('you have a new reminder',
                    style: TextStyle(
                        fontSize: 18,
                        color: Get.isDarkMode
                            ? Colors.grey
                            : MyTheme.darkGreyClr)),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              margin: const EdgeInsets.only(left: 30, right: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: MyTheme.primaryClr),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    createElement(icon: Icons.text_format, text: 'Title'),
                    Text(
                      _payload.toString().split('|')[0],
                      style: const TextStyle(
                          color: Color.fromRGBO(236, 240, 241, 1),
                          fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    createElement(icon: Icons.description, text: 'Description'),
                    Text(
                      _payload.toString().split('|')[1],
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          color: Color.fromRGBO(236, 240, 241, 1),
                          fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    createElement(
                        icon: Icons.calendar_today_outlined, text: 'Date'),
                    Text(
                      _payload.toString().split('|')[2],
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          color: Color.fromRGBO(236, 240, 241, 1),
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
