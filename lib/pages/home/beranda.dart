import 'dart:async';
import 'dart:io';

import 'package:calegplus/components/PengumumanCard.dart';
import 'package:calegplus/components/TopBar.dart';
import 'package:calegplus/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/HomeCard.dart';
import '../../components/helper.dart';
import '../api/api.dart';
import '../auth/login.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  String role = "";
  bool isCaleg = false;
  SharedPreferences? prefs;
  @override
  void initState() {
    super.initState();
    // getKecamatanToTps();
    getDataDpp();
    getDataDpt();
    getRole();
  }

  String dpt = "";
  getRole() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs!.getString("role")!;
      if (role == "CALEG") {
        setState(() {
          isCaleg = true;
          print(isCaleg);
        });
      }
    });
  }

  getDataDpt() async {
    int prosesLoading = 0;
    int prosesLoadingRec = 0;
    Response? response;
    super.initState();
    Dio().options.receiveTimeout = Duration(milliseconds: 8000);
    Dio().options.connectTimeout = Duration(milliseconds: 8000);
    // if (kDebugMode) {
    //   print("object");
    // }
    try {
      response = await Dio().get(
        urlGetDpt,
        onReceiveProgress: (int count, int total) {
          prosesLoadingRec = (count / total * 100).round();
          print("prosesLoading = $prosesLoadingRec");
        },
        options: Options(
            receiveTimeout: const Duration(milliseconds: 8000),
            sendTimeout: const Duration(milliseconds: 8000)),
      );
      if (prosesLoading == 100) {}
    } on DioError catch (e) {
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
      if (response?.statusCode == 200) {
        var responseMap = response?.data;
        setState(() {
          print("responseMap = $responseMap");
          // provinsiList.add(provinsi);
          dpt = "${responseMap['data'] ?? "0"}";
        });
        Timer(Duration(milliseconds: 1000), () async {});
      } else if (response?.statusCode == 400) {
        var responseMap = response?.data;
        betterShowMessage(
            title: '', content: Text(responseMap['message']), context: context);
      } else if (response != null) {
        betterShowMessage(
            title: '',
            content: const Text(
                'Terjadi kesalahan, silahkan coba beberapa saat lagi'),
            context: context);
        print(response.data);
      }
    }
  }

  String dpp = "";
  getDataDpp() async {
    int prosesLoading = 0;
    int prosesLoadingRec = 0;
    Response? response;
    super.initState();
    Dio().options.receiveTimeout = Duration(milliseconds: 8000);
    Dio().options.connectTimeout = Duration(milliseconds: 8000);
    // if (kDebugMode) {
    //   print("object");
    // }
    try {
      response = await Dio().get(
        urlGetDpp,
        onReceiveProgress: (int count, int total) {
          prosesLoadingRec = (count / total * 100).round();
          print("prosesLoading = $prosesLoadingRec");
        },
        options: Options(
            receiveTimeout: const Duration(milliseconds: 8000),
            sendTimeout: const Duration(milliseconds: 8000)),
      );
      if (prosesLoading == 100) {}
    } on DioError catch (e) {
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
      if (response?.statusCode == 200) {
        var responseMap = response?.data;
        setState(() {
          print("responseMap = $responseMap");
          // provinsiList.add(provinsi);
          dpp = "${responseMap['data'] ?? "0"}";
        });
        Timer(Duration(milliseconds: 1000), () async {});
      } else if (response?.statusCode == 400) {
        var responseMap = response?.data;
        betterShowMessage(
            title: '', content: Text(responseMap['message']), context: context);
      } else if (response != null) {
        betterShowMessage(
            title: '',
            content: const Text(
                'Terjadi kesalahan, silahkan coba beberapa saat lagi'),
            context: context);
        print(response.data);
      }
    }
  }
  // getKecamatanToTps() async {
  //   int prosesLoading = 0;
  //   int prosesLoadingRec = 0;
  //   Response? response;
  //   super.initState();
  //   Dio().options.receiveTimeout = Duration(milliseconds: 8000);
  //   Dio().options.connectTimeout = Duration(milliseconds: 8000);
  //   // if (kDebugMode) {
  //   //   print("object");
  //   // }
  //   try {
  //     response = await Dio().get(
  //       urlGetKecamatanTps,
  //       onReceiveProgress: (int count, int total) {
  //         prosesLoadingRec = (count / total * 100).round();
  //         print("prosesLoading = $prosesLoadingRec");
  //       },
  //       options: Options(
  //           headers: {
  //             HttpHeaders.contentTypeHeader: "application/json",
  //           },
  //           receiveTimeout: const Duration(milliseconds: 8000),
  //           sendTimeout: const Duration(milliseconds: 8000)),
  //     );
  //     if (prosesLoading == 100) {}
  //   } on DioError catch (e) {
  //     // if (kDebugMode) {
  //     //   print("e.response = ${e}");
  //     // }
  //     if (e.response != null) {
  //       response = e.response;
  //     } else {
  //       betterShowMessage(
  //         title: "Terjadi kesalahan",
  //         content: Text("${e.message}"),
  //         context: context,
  //         onDefaultOK: () {
  //           Navigator.pop(context);
  //         },
  //       );
  //     }
  //   } finally {
  //     if (response?.statusCode == 200) {
  //       var responseMap = response?.data;
  //       setState(() {
  //         print("responseMap = $responseMap");
  //         // provinsiList.add(provinsi);
  //       });
  //       Timer(Duration(milliseconds: 1000), () async {
  //         setState(() {});
  //       });
  //     } else if (response?.statusCode == 400) {
  //       var responseMap = response?.data;
  //       betterShowMessage(
  //           title: '', content: Text(responseMap['message']), context: context);
  //     } else if (response != null) {
  //       betterShowMessage(
  //           title: '',
  //           content: const Text(
  //               'Terjadi kesalahan, silahkan coba beberapa saat lagi'),
  //           context: context);
  //       print(response.data);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section
              TopBar(),
              // Image.memory(imageData),
              // body
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Beranda",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.bigTitle1),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: HomeCard(
                            topText: "Jumlah DPT",
                            bottomText: dpt == "" ? "loading.." : dpt,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          child: isCaleg
                              ? Expanded(
                                  flex: 1,
                                  child: HomeCard(
                                    topText: "DPT Terkonfirmasi",
                                    bottomText: dpp == "" ? "loading.." : dpp,
                                    color: Colors.green.shade300,
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Pengumuman(
                      topText: "Pengumuman",
                      text: Text("Tidak ada pegumuman",
                          style: TextStyle(fontSize: FontSize.body)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Pengumuman(
                        topText: "Kontak Admin",
                        text: Column(
                          children: [
                            Text("Anom: 0895622720626",
                                style: TextStyle(fontSize: FontSize.body)),
                            // Text("No. HP 2: 098977",
                            //     style: TextStyle(fontSize: FontSize.body)),
                            Text("Email: ofc.calegplus@gmail.com",
                                style: TextStyle(fontSize: FontSize.body)),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
