import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/theme.dart';

class UploadFile extends StatelessWidget {
  UploadFile({super.key, required this.onClick, required this.fileName, this.color = Colors.white});
  void Function() onClick;
  String fileName;
  Color? color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8))),
            padding: EdgeInsets.all(15),
            child: Text(
              fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: AppColors.textBlack, fontSize: FontSize.title),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 50,
            child: GFButton(
              icon: Icon(
                Icons.file_upload_outlined,
                color: Colors.white,
              ),
              onPressed: onClick,
              text: "Pilih File",
              color: AppColors.primary,
              textStyle: GoogleFonts.plusJakartaSans(
                  fontSize: FontSize.title, fontWeight: FontWeight.bold),
              size: GFSize.LARGE,
            ),
          ),
        ),
      ],
    );
  }
}
