import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../theme/theme.dart';

class ProfileInput extends StatelessWidget {
  ProfileInput({
    super.key,
    required this.controller,
    required this.leftText,
    required this.hintText,
  });
  var controller;
  String leftText;
  String hintText;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(leftText),
          flex: 2,
        ),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                fillColor: Colors.grey.shade100,
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
                hintText: hintText,
                hintStyle: TextStyle(fontSize: FontSize.subtitle)),
          ),
          flex: 3,
        )
      ],
    );
  }
}
