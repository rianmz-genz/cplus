import 'package:calegplus/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class InputText extends StatelessWidget {
  InputText(
      {super.key,
      required this.title,
      required this.placeholder,
      required this.type,
      this.color,
      this.colorMaxLength = Colors.red,
      this.helperText,
      this.maxLength = null,
      required this.controller});
  String title;
  String? helperText;
  String placeholder;
  var controller = TextEditingController();
  late var color;
  late var colorMaxLength;
  var type;
  var maxLength;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              TextStyle(color: AppColors.textBlack, fontSize: FontSize.title),
        ),
        Container(
          margin: EdgeInsets.only(top: 6),
          child: TextField(
            controller: controller,
            keyboardType: type,
            maxLength: maxLength,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              fillColor: color ?? Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none),
              hintText: placeholder,
              helperText: helperText ?? helperText,
              helperStyle: TextStyle(fontSize: 11, color: colorMaxLength),
            ),
          ),
        ),
      ],
    );
  }
}
