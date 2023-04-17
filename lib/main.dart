import 'package:calegplus/pages/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:calegplus/pages/auth/register.dart';
import 'package:calegplus/theme/theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const CalegPlus());
}

class CalegPlus extends StatelessWidget {
  const CalegPlus({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      title: "Caleg Plus",
      theme: ThemeCustom.light,
      themeMode: ThemeCustom.themeLight,
      home: Login(),
    );
  }
}
