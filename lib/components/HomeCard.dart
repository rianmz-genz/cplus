import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../theme/theme.dart';

class HomeCard extends StatelessWidget {
  HomeCard(
      {super.key,
      required this.topText,
      required this.bottomText,
      required this.color});
  String topText;
  String bottomText;
  var color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Text(topText,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: FontSize.smallTitle)),
        Text(bottomText,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: FontSize.bigTitle2))
      ]),
    );
  }
}
