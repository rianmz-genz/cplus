import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../theme/theme.dart';

class Pengumuman extends StatelessWidget {
  Pengumuman({super.key, required this.text, required this.topText});
  String topText;
  Widget text;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: Text(topText,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: FontSize.smallTitle)),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.all(12),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: text,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black, spreadRadius: 0.03)],
          ),
          padding: EdgeInsets.all(12),
        ),
      ],
    );
  }
}
