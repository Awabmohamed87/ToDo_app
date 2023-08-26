import 'package:flutter/material.dart';
import 'package:todo_application/ui/theme.dart';

import '../../models/medicine.dart';
import '../size_config.dart';

// ignore: must_be_immutable
class MedicineTile extends StatelessWidget {
  final Medicine medicine;
  const MedicineTile({Key? key, required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenHeight(
              SizeConfig.orientation == Orientation.landscape ? 4 : 20)),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(5)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(colors: [
              medicine.color!,
              Color(medicine.color!.value - 25),
              Colors.grey[700]!
            ]),
            color: medicine.color),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${medicine.title}',
                      style: titleTaskStyle,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey[200],
                          size: 18,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          '${medicine.startTime}',
                          style: timeTaskStyle,
                        ),
                        Text(
                          ' - ${medicine.repeat}',
                          style: timeTaskStyle,
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey[200],
                          size: 18,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          medicine.startDate!.split(',')[1],
                          style: timeTaskStyle,
                        ),
                        Text(
                          ' - ${medicine.endDate!.split(',')[1]}',
                          style: timeTaskStyle,
                        )
                      ],
                    ),
                    Text(
                      '${medicine.note}',
                      style: noteTaskStyle,
                    ),
                  ],
                ),
              ),
            ),
            Image.asset(
              'assets/images/pills.png',
              height: 50,
              color: Colors.white60,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 70,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                '${medicine.numOfShots}/${medicine.totalNumOfShots} pills taken!',
                style: sideMedStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
