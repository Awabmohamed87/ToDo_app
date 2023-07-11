import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_application/ui/size_config.dart';
import 'package:todo_application/ui/theme.dart';

class InputField extends StatelessWidget {
  final String label;
  final String note;
  final TextEditingController? controller;
  final Widget? child;

  const InputField(
      {Key? key,
      required this.label,
      required this.note,
      this.controller,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: titleStyle,
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 4, right: 15, bottom: 10, top: 8),
              padding: const EdgeInsets.only(bottom: 8),
              width: SizeConfig.screenWidth,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: controller,
                    autofocus: false,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    readOnly: child == null ? false : true,
                    style: subTitleStyle,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      hintText: note,
                      hintStyle: subTitleStyle,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: context.theme.colorScheme.background,
                        width: 0,
                        style: BorderStyle.none,
                      )),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: context.theme.colorScheme.background,
                        style: BorderStyle.none,
                        width: 0,
                      )),
                    ),
                  )),
                  child ?? Container(),
                  const SizedBox(
                    width: 5,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
