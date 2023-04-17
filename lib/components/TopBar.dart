import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/auth/login.dart';
import '../theme/theme.dart';
import 'noImage.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  SharedPreferences? prefs;
  String name = "";
  String pp = "";
  // late Uint8List imageProfile = Uint8List.fromList([0]);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }

  getName() async {
    prefs = await SharedPreferences.getInstance();
    // var getData = await MyPreferences.getMap("fotodiri");
    setState(() {
      name = prefs!.getString("name")!;
      pp = prefs!.getString("photoProfile")!;
      // imageProfile = Uint8List.fromList(getData['data']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(24, 36, 24, 16),
      decoration: BoxDecoration(
          color: Colors.orange.shade900,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/LogoWhite.png",
            width: MediaQuery.of(context).size.width * 0.18,
          ),
          Container(
            child: Row(children: [
              Text(
                name,
                style:
                    TextStyle(color: Colors.white, fontSize: FontSize.subtitle),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.width * 0.1,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: pp == ""
                    ? Text("Profile Picture")
                    : ClipRRect(
                        child: Image.memory(
                          base64Decode(pp),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(90),
                      ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
