import 'package:flutter/material.dart';

Future<void> betterShowMessage(
    {required context,
    required String title,
    required Widget content,
    List<Widget>? buttons,
    bool? onDefaultX = false,
    Function()? onDefaultOK}) {
  buttons ??= [
    TextButton(
        onPressed: onDefaultOK ??
            () {
              Navigator.pop(context);
            },
        child: const Text('OK')),
  ];

  return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setState) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16),
                    ),
                    InkWell(
                      child: onDefaultX!
                          ? Icon(Icons.clear)
                          : SizedBox(
                              width: 1,
                            ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ]),
              content: content,
              actions: buttons,
            ),
          );
        });
      });
}
