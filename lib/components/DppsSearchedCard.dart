import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';

import '../theme/theme.dart';

class DppsSearchedCard extends StatelessWidget {
  DppsSearchedCard(
      {super.key,
      required this.name,
      required this.usia,
      required this.color,
      required this.alamat});
  String name;
  String usia;
  String alamat;
  Color? color;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        trailing: Icon(Icons.chevron_right_outlined),
        title: Column(
          children: [
            Row(
              children: [
                Flexible(
                    child: Text(alamat,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: FontSize.subtitle)))
              ],
            ),
            Row(
              children: [
                Flexible(
                    child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: FontSize.title,
                      fontWeight: FontWeight.bold),
                ))
              ],
            ),
            Row(
              children: [
                Flexible(
                    child: Text(usia,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: FontSize.subtitle)))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
