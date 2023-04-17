import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../theme/theme.dart';

class Dropdown extends StatefulWidget {
  Dropdown(
      {super.key,
      required this.list,
      this.width = 0,
      this.color,
      required this.onChange,
      required this.dropdownValue});
  List<String> list = <String>[];
  late double width;
  String dropdownValue;
  late var color;
  void Function(String?)? onChange;
  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  List<String> list = <String>[];
  late double width;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = widget.list;
    width = widget.width;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: widget.color ?? Colors.white,
          borderRadius: BorderRadius.circular(15)),
      child: DropdownButton<String>(
        underline: Text(""),
        value: widget.dropdownValue,
        icon: const Icon(Icons.arrow_drop_down_rounded),
        elevation: 0,
        onChanged: widget.onChange,
        dropdownColor: widget.color ?? Colors.white,
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(fontSize: FontSize.subtitle),
            ),
          );
        }).toList(),
      ),
    );
  }
}
