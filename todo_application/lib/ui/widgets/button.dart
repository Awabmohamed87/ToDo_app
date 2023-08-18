import 'package:flutter/material.dart';
import 'package:todo_application/ui/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function() onTap;

  const MyButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: MyTheme.primaryClr, borderRadius: BorderRadius.circular(10)),
        width: label == '+ Add Task' ? 100 : 130,
        height: 40,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
