import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_application/controllers/medicine_controller.dart';
import 'package:todo_application/ui/size_config.dart';
import 'package:todo_application/ui/theme.dart';

import '../../models/medicine.dart';

class AlarmScreen extends StatefulWidget {
  final int id;
  const AlarmScreen({super.key, required this.id});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final MedicineController _medicineController = MedicineController();
  Medicine? med;

  @override
  void initState() {
    _medicineController.getMedicine(widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        onEnd: () {},
        decoration: const BoxDecoration(
          gradient: RadialGradient(
              radius: 4.0,
              colors: [MyTheme.primaryClr, Colors.white54],
              tileMode: TileMode.mirror),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Time for your pill', style: headingStyle),
            const SizedBox(height: 5),
            FutureBuilder(
                future: _medicineController.getMedicine(widget.id),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return Text(snapshot.data!, style: subHeadingStyle);
                  return Container();
                })),
            Container(
              margin: EdgeInsets.only(left: SizeConfig.screenWidth * 0.08),
              child: Image.asset(
                'assets/images/pills.png',
                height: SizeConfig.screenHeight * 0.3,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  Alarm.stop(widget.id);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white60,
                    fixedSize: const Size(150, 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: const Text('Stop',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)))
          ],
        )),
      ),
    );
  }
}
