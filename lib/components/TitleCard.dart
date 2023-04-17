import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TitleCard extends StatelessWidget {
  TitleCard({super.key, required this.title, required this.icon});
  String title;
  Icon icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
      decoration: BoxDecoration(color: Colors.grey.shade100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: icon,
          ),
          SizedBox(
            width: 2,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
