import 'dart:async';
import 'dart:io';

import 'package:calegplus/pages/auth/register2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../components/helper.dart';
import '../../theme/theme.dart';
import '../../components/Input.dart';
import '../../components/InputPassword.dart';
import '../../components/Dropdown.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';

import '../api/api.dart';
import 'login.dart';

class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var fullNameController = TextEditingController();
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var rtController = TextEditingController();
  var rwController = TextEditingController();
  var isLoading = true;
  List<String> provinsiList = ["Provinsi"];
  List<String> kabupatenList = ['Kabupaten'];
  List<String> kecamatanList = ['Kecamatan'];
  List<String> kelurahanList = ['Kelurahan'];
  List<dynamic> prov = [];
  List<dynamic> kab = [];
  List<dynamic> kec = [];
  String kecamatanValue = "Kecamatan";
  String kelurahanValue = "Kelurahan";
  String kabupatenValue = "Kabupaten";
  String provinsiValue = "Provinsi";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProvinsi();
  }

  getProvinsi() async {
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
        urlGetProvinsi,
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
      if (kDebugMode) {
        // print("responseMap = ${response?.data['uid']}");
      }
      if (response?.statusCode == 200) {
        var responseMap = response?.data['data'];
        for (var res in responseMap) {
          setState(() {
            provinsiList.add(res['name']);
            prov = responseMap;
            print(prov);
          });
        }
        setState(() {
          // print("responseMap = $responseMap");
          // provinsiList.add(provinsi);
        });
        Timer(Duration(milliseconds: 1000), () async {
          setState(() {
            isLoading = false;
          });
        });
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

  getKabupaten(String id) async {
    int prosesLoading = 0;
    int prosesLoadingRec = 0;
    Response? response;
    Dio().options.receiveTimeout = Duration(milliseconds: 8000);
    Dio().options.connectTimeout = Duration(milliseconds: 8000);
    // if (kDebugMode) {
    //   print("object");
    // }
    try {
      response = await Dio().get(
        "${urlGetKabupaten}/${id}",
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
      if (kDebugMode) {
        // print("responseMap = ${response?.data['uid']}");
      }
      if (response?.statusCode == 200) {
        var responseMap = response?.data['data'];
        for (var res in responseMap) {
          setState(() {
            kab = responseMap;
            kabupatenList.add(res['name']);
          });
          print(kab);
        }
        setState(() {
          // print("responseMap = $responseMap");
          // provinsiList.add(provinsi);
        });
        Timer(Duration(milliseconds: 1000), () async {
          setState(() {
            isLoading = false;
          });
        });
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

  getKecamatan(String id) async {
    int prosesLoading = 0;
    int prosesLoadingRec = 0;
    Response? response;
    Dio().options.receiveTimeout = Duration(milliseconds: 8000);
    Dio().options.connectTimeout = Duration(milliseconds: 8000);
    // if (kDebugMode) {
    //   print("object");
    // }
    try {
      response = await Dio().get(
        "${urlGetKecamatan}/${id}",
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
      if (kDebugMode) {
        // print("responseMap = ${response?.data['uid']}");
      }
      if (response?.statusCode == 200) {
        var responseMap = response?.data['data'];
        for (var res in responseMap) {
          print(res['name']);
          setState(() {
            kec = responseMap;
            kecamatanList.add(res['name']);
            print(responseMap);
          });
        }
        setState(() {
          // print("responseMap = $responseMap");
          // provinsiList.add(provinsi);
        });
        Timer(Duration(milliseconds: 1000), () async {
          setState(() {
            isLoading = false;
          });
        });
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

  getDesa(String id) async {
    int prosesLoading = 0;
    int prosesLoadingRec = 0;
    Response? response;
    Dio().options.receiveTimeout = Duration(milliseconds: 8000);
    Dio().options.connectTimeout = Duration(milliseconds: 8000);
    // if (kDebugMode) {
    //   print("object");
    // }
    try {
      response = await Dio().get(
        "${urlGetDesa}/${id}",
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
      if (kDebugMode) {
        // print("responseMap = ${response?.data['uid']}");
      }
      if (response?.statusCode == 200) {
        var responseMap = response?.data['data'];
        for (var res in responseMap) {
          print(res['name']);
          setState(() {
            kelurahanList.add(res['name']);
          });
        }
        setState(() {
          print("responseMap = $responseMap");
          // provinsiList.add(provinsi);
        });
        Timer(Duration(milliseconds: 1000), () async {
          setState(() {
            isLoading = false;
          });
        });
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Registrasi Akun!",
                            style: TextStyle(
                                color: AppColors.textBlack,
                                fontSize: FontSize.bigTitle1,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Registrasi Agar Dapat Masuk Ke Aplikasi!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.textBlack,
                                fontSize: FontSize.title),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          InputText(
                            title: "Nama Lengkap*",
                            placeholder: 'Contoh: “Sapon Paiman Darmaji”',
                            controller: fullNameController,
                            type: TextInputType.text,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          InputText(
                            title: "Nama Pengguna*",
                            placeholder: 'Masukan Nama Pengguna',
                            controller: usernameController,
                            type: TextInputType.text,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          InputText(
                            title: "Email*",
                            placeholder: 'Masukan Email',
                            controller: emailController,
                            type: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          InputPassword(
                            hintText: "Kata Sandi",
                            title: "Kata Sandi*",
                            controller: passwordController,
                            isMaxLength: true,
                            isHelper: true,
                            helperText:
                                "Kombinasi angka, huruf kapital dan huruf kecil",
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          InputPassword(
                            hintText: "Ketik ulang kata sandi",
                            title: "Konfirmasi Kata Sandi*",
                            controller: confirmPasswordController,
                            isMaxLength: true,
                            isHelper: false,
                            helperText: "",
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Alamat*",
                                  style: TextStyle(
                                      color: AppColors.textBlack,
                                      fontSize: FontSize.title),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: isLoading
                                      ? Text("Loading...")
                                      : Dropdown(
                                          dropdownValue: provinsiValue,
                                          list: provinsiList,
                                          onChange: (String? value) {
                                            // This is called when the user selects an item.
                                            setState(() {
                                              provinsiValue = value!;
                                              var filteredprov = prov
                                                  .where((element) =>
                                                      element['name'] ==
                                                      provinsiValue)
                                                  .toList();
                                              var idcurrentprov =
                                                  filteredprov[0]['id'];
                                              kabupatenList.clear();
                                              kabupatenList.add("Kabupaten");
                                              getKabupaten(idcurrentprov);
                                            });
                                          },
                                        ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: isLoading
                                      ? Text("Loading...")
                                      : Dropdown(
                                          onChange: (String? value) {
                                            // This is called when the user selects an item.
                                            setState(() {
                                              kabupatenValue = value!;
                                              var filteredkab = kab
                                                  .where((element) =>
                                                      element['name'] ==
                                                      kabupatenValue)
                                                  .toList();
                                              var idcurrentkab =
                                                  filteredkab[0]['id'];
                                              print(idcurrentkab);
                                              kecamatanList.clear();
                                              kecamatanList.add("Kecamatan");
                                              getKecamatan(idcurrentkab);
                                            });
                                          },
                                          dropdownValue: kabupatenValue,
                                          list: kabupatenList,
                                        ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: isLoading
                                      ? Text("Loading...")
                                      : Dropdown(
                                          dropdownValue: kecamatanValue,
                                          list: kecamatanList,
                                          onChange: (String? value) {
                                            // This is called when the user selects an item.
                                            setState(() {
                                              kecamatanValue = value!;
                                              var filteredkec = kec
                                                  .where((element) =>
                                                      element['name'] ==
                                                      kecamatanValue)
                                                  .toList();
                                              var idcurrentkec =
                                                  filteredkec[0]['id'];

                                              kelurahanList.clear();
                                              kelurahanList.add("Kelurahan");
                                              getDesa(idcurrentkec);
                                            });
                                          },
                                        ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: isLoading
                                      ? Text("Loading...")
                                      : Dropdown(
                                          dropdownValue: kelurahanValue,
                                          list: kelurahanList,
                                          onChange: (String? value) {
                                            // This is called when the user selects an item.
                                            setState(() {
                                              kelurahanValue = value!;
                                            });
                                          },
                                        ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.44,
                                      margin: EdgeInsets.only(top: 6),
                                      child: TextField(
                                        controller: rtController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none),
                                          disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none),
                                          hintText: "RT, Cth: 001",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.44,
                                      margin: EdgeInsets.only(top: 6),
                                      child: TextField(
                                        controller: rwController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none),
                                          disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none),
                                          hintText: "RW, Cth: 002",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 16),
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  child: GFButton(
                                    onPressed: () {
                                      var filterProvinsi =
                                          provinsiList.indexWhere((element) =>
                                              element == provinsiValue);
                                      var filterKabupaten =
                                          kabupatenList.indexWhere((element) =>
                                              element == kabupatenValue);
                                      var filterKecamatan =
                                          kecamatanList.indexWhere((element) =>
                                              element == kecamatanValue);
                                      var filterKelurahan =
                                          kelurahanList.indexWhere((element) =>
                                              element == kelurahanValue);
                                      if (filterProvinsi == 0 ||
                                          filterKabupaten == 0 ||
                                          filterKelurahan == 0 ||
                                          filterKecamatan == 0) {
                                        betterShowMessage(
                                            context: context,
                                            title: "",
                                            content: Text(
                                                "Harap pilih alamat terlebih dahulu"));
                                        return;
                                      }
                                      if (fullNameController.text.isEmpty ||
                                          usernameController.text.isEmpty ||
                                          emailController.text.isEmpty ||
                                          passwordController.text.isEmpty ||
                                          confirmPasswordController
                                              .text.isEmpty ||
                                          rtController.text.isEmpty ||
                                          rwController.text.isEmpty) {
                                        betterShowMessage(
                                            context: context,
                                            title: "",
                                            content: Text(
                                                "Harap lengkapi data terlebih dahulu"));
                                        return;
                                      }
                                      if (passwordController.text.length <= 7) {
                                        betterShowMessage(
                                            context: context,
                                            title: "",
                                            content: Text(
                                                "Kata sandi harus berjumlah 8 karakter"));
                                        return;
                                      }
                                      if (usernameController.text.length <= 5) {
                                        betterShowMessage(
                                            context: context,
                                            title: "",
                                            content: Text(
                                                "Nama pengguna minimal berjumlah 6 karakter"));
                                        return;
                                      }

                                      if (passwordController.text !=
                                          confirmPasswordController.text) {
                                        betterShowMessage(
                                            context: context,
                                            title: "",
                                            content: Text(
                                                "Kata sandi dan konfirmasi kata sandi tidak cocok."));
                                        return;
                                      }
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) => Register2(
                                                    password:
                                                        passwordController.text,
                                                    email: emailController.text,
                                                    fullname:
                                                        fullNameController.text,
                                                    username:
                                                        usernameController.text,
                                                    address:
                                                        "${provinsiValue}, ${kabupatenValue}, ${kecamatanValue}, ${kelurahanValue}, RT${rtController.text}/RW${rwController.text}",
                                                  ))));
                                    },
                                    text: "Selanjutnya",
                                    color: AppColors.primary,
                                    textStyle: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
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
                                    Text('Sudah Memiliki akun?'),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    Login())));
                                      },
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}
