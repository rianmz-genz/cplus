import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:calegplus/pages/auth/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/Navbar.dart';
import '../../components/ProfileInput.dart';
import '../../components/ProfileItem.dart';
import '../../components/TopBar.dart';
import '../../components/helper.dart';
import '../../theme/theme.dart';
import '../api/api.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences? prefs;
  var oldPass = TextEditingController();
  var newPass = TextEditingController();
  var confirmPass = TextEditingController();
  String name = "";
  String status = "";
  String areaKerja = "";
  String address = "";
  String pp = "";
  bool isHitApi = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }

  getName() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs!.getString("name")!;
      status = prefs!.getString("role")!;
      areaKerja = prefs!.getString("workingArea")!;
      address = prefs!.getString("address")!;
      pp = prefs!.getString("photoProfile")!;
    });
  }

  processUpdatePassword() async {
    setState(() {
      isHitApi = true;
    });
    final bodyy = json.encode({
      "oldPassword": oldPass.text,
      "newPassword": newPass.text,
      "confirmNewPassword": confirmPass.text,
    });
    prefs = await SharedPreferences.getInstance();
    int prosesLoading = 0;
    int prosesLoadingRec = 0;
    Response? response;
    // if (kDebugMode) {
    //   print("object");
    // }

    try {
      response = await Dio().put(
        urlUpdatePassword,
        data: bodyy,
        onSendProgress: (int count, int total) {
          prosesLoading = (count / total * 100).round();
          print("prosesLoading = $prosesLoading");
          EasyLoading.show(
            status: 'Loading..',
            maskType: EasyLoadingMaskType.black,
          );
        },
        onReceiveProgress: (int count, int total) {
          prosesLoadingRec = (count / total * 100).round();
          print("prosesLoading = $prosesLoadingRec");
        },
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader:
                "Bearer ${prefs!.getString("token")}",
          },
        ),
      );
      if (prosesLoading == 100) {
        EasyLoading.dismiss();
      }
    } on DioError catch (e) {
      EasyLoading.showError('Ubah Kata Sandi Gagal!');
      // if (kDebugMode) {
      //   print("e.response = ${e}");
      // }
      if (e.response != null) {
        response = e.response;
      } else {
        betterShowMessage(
          title: "Terjadi kesalahan",
          content: Text("${e.message}"),
          context: context,
          onDefaultOK: () {
            Navigator.pop(context);
          },
        );
      }
    } finally {
      if (kDebugMode) {
        // print("responseMap = ${response?.data['uid']}");
      }
      if (response?.statusCode == 200) {
        var responseMap = response?.data;

        setState(() {
          print("responseMap = $responseMap");
          isHitApi = false;
          print("Bearer ${prefs!.getString("token")}");
        });
        EasyLoading.showSuccess("Berhasil");
        if (responseMap == null) {
          return;
        }
        Timer(Duration(milliseconds: 1000), () async {
          EasyLoading.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Navbar(
                        seciliIndex: 0,
                      )));
        });
      } else if (response?.statusCode == 400) {
        var responseMap = response?.data;
        setState(() {
          isHitApi = false;
        });
        betterShowMessage(
            title: 'Ubah Kata Sandi Gagal',
            content: Text(responseMap['message']),
            context: context);
      } else if (response != null) {
        var msg = response.data['message'];
        setState(() {
          isHitApi = false;
        });
        betterShowMessage(
            title: 'Ubah Kata Sandi Gagal',
            content: Text('${msg}'),
            context: context);
        print(response.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBar(),
              SizedBox(
                height: 12,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize.bigTitle1),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                      color: Colors.white,
                                    ),
                                    child: pp == ""
                                        ? Text("Profile Picture")
                                        : ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(90)),
                                            child: Image.memory(
                                              base64Decode(pp),
                                              fit: BoxFit.cover,
                                              width: 150,
                                              height: 150,
                                            ),
                                          )),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                      fontSize: FontSize.title,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 12,
                        ),
                        ProfileItem(
                          leftText: "Alamat",
                          rightText: address,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        ProfileItem(
                          leftText: "Status",
                          rightText: status,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        ProfileItem(
                          leftText: "Daerah Kerja",
                          rightText: areaKerja,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: Colors.grey.shade200,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Keamanan",
                          style: TextStyle(
                              fontSize: FontSize.title,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: Colors.grey.shade200,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Ubah Kata Sandi",
                          style: TextStyle(
                              fontSize: FontSize.title,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        ProfileInput(
                          leftText: "Kata sandi lama",
                          hintText: "Kata sandi lama",
                          controller: oldPass,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        ProfileInput(
                          leftText: "Kata sandi baru",
                          hintText: "Kata sandi baru",
                          controller: newPass,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        ProfileInput(
                          leftText: "Konfirmasi kata sandi",
                          hintText: "Konfirmasi kata sandi",
                          controller: confirmPass,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GFButton(
                              icon: Icon(
                                Icons.change_circle,
                                color: Colors.white,
                                size: FontSize.title,
                              ),
                              onPressed: () {
                                if (oldPass.text.isEmpty ||
                                    newPass.text.isEmpty ||
                                    confirmPass.text.isEmpty) {
                                  betterShowMessage(
                                      title: '',
                                      content: const Text(
                                          'Harap isi data terlebih dahulu'),
                                      context: context);
                                  return;
                                }
                                processUpdatePassword();
                              },
                              text: "Ubah",
                              color: AppColors.primary,
                              textStyle: GoogleFonts.plusJakartaSans(
                                  fontSize: FontSize.smallTitle,
                                  fontWeight: FontWeight.bold),
                              size: GFSize.LARGE,
                              shape: GFButtonShape.pills,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        InkWell(
                          onTap: () async {
                            prefs = await SharedPreferences.getInstance();
                            prefs?.remove("token");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Container(
                            color: Colors.grey.shade100,
                            padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                            margin: EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(Icons.logout_rounded),
                                Text("Logout")
                              ],
                            ),
                          ),
                        ),
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}
