import 'package:calegplus/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class InputPassword extends StatefulWidget {
  InputPassword(
      {super.key,
      required this.hintText,
      required this.title,
      required this.helperText,
      required this.isMaxLength,
      required this.isHelper,
      required this.controller});
  var controller = TextEditingController();
  final String title;
  final String hintText;
  late String? helperText;
  late bool isMaxLength = false;
  late bool isHelper = false;
  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style:
              TextStyle(color: AppColors.textBlack, fontSize: FontSize.title),
        ),
        Container(
          margin: EdgeInsets.only(top: 6),
          child: TextField(
            controller: widget.controller,
            obscureText: _obscureText,
            maxLength: widget.isMaxLength ? 8 : null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              fillColor: Colors.white,
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
              filled: true,
              hintText: widget.hintText,
              helperStyle: TextStyle(fontSize: 11),
              helperText: widget.isHelper ? widget.helperText : null,
              suffixIcon: new GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: new Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
