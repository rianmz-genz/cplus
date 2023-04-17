import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:calegplus/components/InputPassword.dart';
import 'package:calegplus/components/Navbar.dart';
import 'package:calegplus/pages/auth/register.dart';
import 'package:calegplus/pages/home/beranda.dart';
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

import '../../components/Input.dart';
import '../../components/helper.dart';
import '../../components/noImage.dart';
import '../../theme/theme.dart';
import '../api/api.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var username = TextEditingController();
  var password = TextEditingController();
  bool isHitApi = false;
  Map<String, dynamic> response = {};
  SharedPreferences? prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autoLogin();
  }

  autoLogin() async {
    prefs = await SharedPreferences.getInstance();
    var autoToken = prefs?.getString("token");
    print(autoToken ?? "no");
    if (autoToken != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Navbar(
                    seciliIndex: 0,
                  )));
    }
  }

  var helperText = null;
  processLogin(username, password) async {
    setState(() {
      isHitApi = true;
    });
    int prosesLoading = 0;
    int prosesLoadingRec = 0;
    Response? response;
    Dio().options.receiveTimeout = Duration(milliseconds: 8000);
    Dio().options.connectTimeout = Duration(milliseconds: 8000);
    // if (kDebugMode) {
    //   print("object");
    // }
    final body = json.encode({
      'username': "${username}",
      'password': "${password}",
    });
    print(body);
    try {
      response = await Dio().post(
        urlLogin,
        data: body,
        onSendProgress: (int count, int total) {
          prosesLoading = (count / total * 100).round();
          print("prosesLoading = $prosesLoading");
          EasyLoading.show(
            status: 'Loading ${prosesLoading}%',
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
            },
            receiveTimeout: const Duration(milliseconds: 8000),
            sendTimeout: const Duration(milliseconds: 8000)),
      );
      if (prosesLoading == 100) {
        EasyLoading.dismiss();
      }
    } on DioError catch (e) {
      EasyLoading.showError('Login Gagal!');
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
        var email = responseMap['data']['user']['email'];
        var token = responseMap['token'];
        var username = responseMap['data']['user']['username'];
        var name = responseMap['data']['user']['name'];
        var address = responseMap['data']['user']['address'];
        var workingArea = responseMap['data']['user']['working_area'];
        var photo = responseMap['data']['user']['photo'];
        var photoKtp = responseMap['data']['user']['photo_ktp'];
        var role = responseMap['data']['user']['role'];

        setState(() {
          print("responseMap = $responseMap");
          print(email);
          isHitApi = false;
        });

        EasyLoading.showSuccess('Login Berhasil!');
        Timer(Duration(milliseconds: 1000), () async {
          prefs = await SharedPreferences.getInstance();
          setState(() {
            prefs!.setString("token", token);
            prefs!.setString("email", email);
            prefs!.setString("username", username);
            prefs!.setString("password", password);
            prefs!.setString("name", name);
            prefs!.setString("address", address);
            prefs!.setString("workingArea", workingArea);
            prefs!.setString("photoProfile", photo ?? noImage);
            // MyPreferences.setMap("fotodiri", photo);
            prefs!.setString("role", role);
          });
          if (kDebugMode) {
            print(prefs!.getString("name"));
            print(prefs!.getString("password"));
            print(prefs!.getString("token"));
            print(prefs!.getString("role"));
            print(prefs!.getString("photoProfile"));
          }
          EasyLoading.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => Navbar(
                        seciliIndex: 0,
                      ))));
        });
      } else if (response?.statusCode == 400) {
        var responseMap = response?.data;
        setState(() {
          isHitApi = false;
        });
        betterShowMessage(
            title: 'Login Gagal',
            content: Text(responseMap['message']),
            context: context);
      } else if (response != null) {
        var msg = response.data['message'];
        setState(() {
          isHitApi = false;
        });
        betterShowMessage(
            title: 'Login Gagal', content: Text('${msg}'), context: context);
        print(response.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  Image.asset(
                    "assets/LogoCPlus 2.png",
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.03),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Selamat Datang!",
                            style: TextStyle(
                                color: AppColors.textBlack,
                                fontSize: FontSize.bigTitle1,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Silahkan login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.textBlack,
                                fontSize: FontSize.title),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          InputText(
                            helperText: helperText,
                            title: "Nama Pengguna*",
                            placeholder: 'nama pengguna',
                            controller: username,
                            type: TextInputType.text,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          InputPassword(
                            title: "Kata Sandi*",
                            hintText: "Kata Sandi",
                            controller: password,
                            helperText: "",
                            isMaxLength: false,
                            isHelper: false,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: GFButton(
                              onPressed: () {
                                setState(() {
                                  if (username.text.isEmpty &&
                                      password.text.isEmpty) {
                                    helperText =
                                        "Masukan nama pengguna atau password terlebih dahulu.";
                                    Timer(
                                      Duration(seconds: 4),
                                      () => setState(() {
                                        helperText = null;
                                      }),
                                    );
                                    return;
                                  }

                                  processLogin(username.text, password.text);
                                  print("halo");
                                });
                              },
                              text: isHitApi ? "Loading..." : "Login",
                              color: AppColors.primary,
                              textStyle: GoogleFonts.plusJakartaSans(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              size: GFSize.LARGE,
                              shape: GFButtonShape.pills,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Belum Memiliki akun?'),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()));
                                },
                                child: Text(
                                  'Registrasi',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

class MyPreferences {
  static Future<Map<String, dynamic>> getMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = prefs.getString(key) ?? '{}';
    final Map<String, dynamic> map = jsonDecode(jsonString);
    return map;
  }

  static Future<void> setMap(String key, Map<String, dynamic> map) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(map);
    await prefs.setString(key, jsonString);
  }
}
