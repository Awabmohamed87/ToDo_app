import 'package:flutter/material.dart';
import 'package:todo_application/ui/theme.dart';

import '../../models/task.dart';
import '../size_config.dart';

// ignore: must_be_immutable
class TaskTile extends StatelessWidget {
  final Task task;
  TaskTile({Key? key, required this.task}) : super(key: key);

  List<Color> colors = [MyTheme.primaryClr, MyTheme.pinkClr, MyTheme.orangeClr];
  Color _getColor(index) => colors[index];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenHeight(
              SizeConfig.orientation == Orientation.landscape ? 4 : 20)),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _getColor(task.color)),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${task.title}',
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
                          '${task.startTime} - ${task.endTime}',
                          style: timeTaskStyle,
                        )
                      ],
                    ),
                    Text(
                      '${task.note}',
                      style: noteTaskStyle,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task.isCompleted == 1 ? 'Completed' : 'ToDO',
                style: sideTaskStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
