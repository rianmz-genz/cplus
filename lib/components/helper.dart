import 'package:flutter/material.dart';

Future<void> betterShowMessage(
    {required context,
    required String title,
    required Widget content,
    List<Widget>? buttons,
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
              title: Text(title),
              content: content,
              actions: buttons,
            ),
          );
        });
      });
}
