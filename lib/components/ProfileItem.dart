import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../theme/theme.dart';

class ProfileItem extends StatelessWidget {
  ProfileItem({
    super.key,
    required this.rightText,
    required this.leftText,
  });

  String leftText;
  String rightText;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.shade100,
      padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
  
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      leftText,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      ": $rightText",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
        ],
      ),
    );
  }
}