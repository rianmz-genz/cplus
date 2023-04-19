import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:calegplus/pages/auth/login.dart';
import 'package:calegplus/pages/auth/register.dart';
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
import 'package:image_picker/image_picker.dart';
import '../../components/Dropdown.dart';
import '../../components/Input.dart';
import '../../components/UploadFile.dart';
import '../../components/helper.dart';
import '../../theme/theme.dart';
import '../api/api.dart';

class Register2 extends StatefulWidget {
  Register2(
      {super.key,
      required this.username,
      required this.address,
      required this.email,
      required this.password,
      required this.fullname});
  String username;
  String fullname;
  String email;
  String address;
  String password;
  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  late File fotoDiri;
  String fotoDiriBase64 = "";
  late String fotoDiriName = "Tidak ada file";
  late File fotoKtp;
  String fotoKtpBase64 = "";
  late String fotoKtpName = "Tidak ada file";
  var noWaController = TextEditingController();
  var areaKerjaController = TextEditingController();
  bool isHitApi = false;
  List<String> jabatanTugasList = <String>[
    'Jabatan Tugas',
    'SAKSI TPS',
    'KOORDINATOR DESA',
    'CALEG',
  ];
  String jabatanValue = "Jabatan Tugas";
  Future<File> testCompressAndGetFileKtp(File file) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = dir.absolute.path + '/temp.jpeg';

    List<Map<String, int>> resolutions = [
      {
        "width": 1080,
        "height": 1920,
      },
      {
        "width": 720,
        "height": 1280,
      },
      {
        "width": 480,
        "height": 640,
      },
      {
        "width": 240,
        "height": 320,
      },
    ];
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 1,
      format: CompressFormat.jpeg,
    );

    print(file.lengthSync());
    print(result!.lengthSync());

    return result;
  }

  _getFotoDiriFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      Uint8List imgbytes1 = imageTemp.readAsBytesSync();
      String fileBase64 = base64Encode(imgbytes1);
      setState(() {
        if (kDebugMode) {
          print('Nama File ${image.name}');
          print(fileBase64);
          fotoDiriName = image.name;
        }
        // this.image = imageTemp;
        // imageController.text = imageName;
        testCompressAndGetFileKtp(
          imageTemp,
        ).then((value) {
          if (kDebugMode) {
            print('Nama File ${value.path}');
          }
          setState(() {
            final bytes = File(value.path).readAsBytesSync();
            fotoDiriBase64 = base64Encode(bytes);
          });
        });
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  _getFotoDiriFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      Uint8List imgbytes1 = imageTemp.readAsBytesSync();
      String fileBase64 = base64Encode(imgbytes1);
      setState(() {
        if (kDebugMode) {
          print('Nama File ${image.name}');
          print(fileBase64);
          fotoDiriName = image.name;
        }
        // this.image = imageTemp;
        // imageController.text = imageName;
        testCompressAndGetFileKtp(
          imageTemp,
        ).then((value) {
          if (kDebugMode) {
            print('Nama File ${value.path}');
          }
          setState(() {
            final bytes = File(value.path).readAsBytesSync();
            fotoDiriBase64 = base64Encode(bytes);
          });
        });
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  _getFotoKtpFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      Uint8List imgbytes1 = imageTemp.readAsBytesSync();
      String fileBase64 = base64Encode(imgbytes1);
      setState(() {
        if (kDebugMode) {
          print('Nama File ${image.name}');
          print(fileBase64);
          fotoKtpName = image.name;
        }
        // this.image = imageTemp;
        // imageController.text = imageName;
        testCompressAndGetFileKtp(
          imageTemp,
        ).then((value) {
          if (kDebugMode) {
            print('Nama File ${value.path}');
          }
          setState(() {
            final bytes = File(value.path).readAsBytesSync();
            fotoKtpBase64 = base64Encode(bytes);

            print(fotoKtpBase64);
          });
        });
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  _getFotoKtpFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      Uint8List imgbytes1 = imageTemp.readAsBytesSync();
      String fileBase64 = base64Encode(imgbytes1);
      setState(() {
        if (kDebugMode) {
          print('Nama File ${image.name}');
          print(fileBase64);
          fotoKtpName = image.name;
        }
        // this.image = imageTemp;
        // imageController.text = imageName;
        testCompressAndGetFileKtp(
          imageTemp,
        ).then((value) {
          if (kDebugMode) {
            print('Nama File ${value.path}');
          }
          setState(() {
            final bytes = File(value.path).readAsBytesSync();
            fotoKtpBase64 = base64Encode(bytes);

            print(fotoKtpBase64);
          });
        });
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  processRegister() async {
    setState(() {
      isHitApi = true;
    });
    final body = json.encode({
      "email": "${widget.email}",
      "username": "${widget.username}",
      "password": "${widget.password}",
      "phone": "${noWaController.text}",
      "role": "${jabatanValue}",
      "photo": fotoDiriBase64 == "" ? null : fotoDiriBase64,
      "photo_ktp": fotoKtpBase64 == "" ? null : fotoKtpBase64,
      "name": "${widget.fullname}",
      "address": "${widget.address}",
      "working_area": "${areaKerjaController.text}",
    });
    print(widget.email);
    print(widget.username);
    print(widget.password);
    print(noWaController.text);
    print(jabatanValue);
    print(fotoDiriBase64);
    print(fotoKtpBase64);
    print(widget.fullname);
    print(widget.address);
    print(areaKerjaController.text);
    int prosesLoading = 0;
    int prosesLoadingRec = 0;
    Response? response;
    Dio().options.receiveTimeout = Duration(milliseconds: 8000);
    Dio().options.connectTimeout = Duration(milliseconds: 8000);
    // if (kDebugMode) {
    //   print("object");
    // }
    try {
      response = await Dio().post(
        urlRegister,
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
      EasyLoading.showError('Registrasi Gagal!');
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
        if (responseMap == null) {
          betterShowMessage(
              title: 'Registrasi Gagal',
              content: Text("ukuran foto terlalu besar."),
              context: context);
          return isHitApi = false;
        }
        EasyLoading.showSuccess('Registrasi Berhasil, Silahkan Login!');
        setState(() {
          print("responseMap = $responseMap");
          isHitApi = false;
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => Register())));
        });

        Timer(Duration(milliseconds: 1000), () async {
          EasyLoading.dismiss();
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => Login())));
        });
      } else if (response?.statusCode == 400) {
        var responseMap = response?.data;
        setState(() {
          isHitApi = false;
        });
        betterShowMessage(
            title: 'Registrasi Gagal',
            content: Text(responseMap['message']),
            context: context);
      } else if (response != null) {
        setState(() {
          isHitApi = false;
        });
        var msg = response.data;
        betterShowMessage(
            title: 'Registrasi Gagal',
            content: Text('${msg}'),
            context: context);
        print(response.data);
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => Login())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                        color: AppColors.textBlack, fontSize: FontSize.title),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InputText(
                    title: "No. HP(WA)*",
                    placeholder: 'Contoh: “08255642258”',
                    controller: noWaController,
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jabatan Tugas*",
                        style: TextStyle(
                            color: AppColors.textBlack,
                            fontSize: FontSize.title),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Dropdown(
                          dropdownValue: jabatanValue,
                          onChange: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              jabatanValue = value!;
                            });
                          },
                          list: jabatanTugasList,
                          width: MediaQuery.of(context).size.width),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  InputText(
                    title: "Area Kerja*",
                    placeholder: 'Masukkan area kerja...',
                    controller: areaKerjaController,
                    type: TextInputType.text,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Foto Diri(Opsional)",
                          style: TextStyle(
                              color: AppColors.textBlack,
                              fontSize: FontSize.title),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        UploadFile(
                          fileName: fotoDiriName,
                          onClick: () {
                            betterShowMessage(
                                title: 'Pilih metode',
                                content: Text(''),
                                onDefaultX: true,
                                buttons: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 60,
                                        child: GFButton(
                                          onPressed: () {
                                            _getFotoDiriFromGallery();
                                            Navigator.pop(context);
                                          },
                                          text: "Dari Gallery",
                                          color: AppColors.primary,
                                          textStyle:
                                              GoogleFonts.plusJakartaSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                          size: GFSize.LARGE,
                                        ),
                                      ),
                                      Container(
                                        height: 60,
                                        child: GFButton(
                                          onPressed: () {
                                            _getFotoDiriFromCamera();
                                            Navigator.pop(context);
                                          },
                                          text: "Dari Kamera",
                                          color: AppColors.primary,
                                          textStyle:
                                              GoogleFonts.plusJakartaSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                          size: GFSize.LARGE,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                                context: context);
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Foto KTP(Opsional)",
                          style: TextStyle(
                              color: AppColors.textBlack,
                              fontSize: FontSize.title),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        UploadFile(
                          fileName: fotoKtpName,
                          onClick: () {
                            betterShowMessage(
                                title: 'Pilih metode',
                                content: Text(''),
                                onDefaultX: true,
                                buttons: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 60,
                                        child: GFButton(
                                          onPressed: () {
                                            _getFotoKtpFromGallery();
                                            Navigator.pop(context);
                                          },
                                          text: "Dari Gallery",
                                          color: AppColors.primary,
                                          textStyle:
                                              GoogleFonts.plusJakartaSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                          size: GFSize.LARGE,
                                        ),
                                      ),
                                      Container(
                                        height: 60,
                                        child: GFButton(
                                          onPressed: () {
                                            _getFotoKtpFromCamera();
                                            Navigator.pop(context);
                                          },
                                          text: "Dari Kamera",
                                          color: AppColors.primary,
                                          textStyle:
                                              GoogleFonts.plusJakartaSans(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                          size: GFSize.LARGE,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                                context: context);
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: GFButton(
                            onPressed: () {
                              if (noWaController.text.isEmpty ||
                                  jabatanValue == "Jabatan Tugas" ||
                                  areaKerjaController.text.isEmpty) {
                                betterShowMessage(
                                    context: context,
                                    title: "",
                                    content:
                                        Text("Lengkapi data terlebih dahulu"));
                                return;
                              }
                              if (isHitApi == true) {
                                return;
                              }
                              processRegister();
                            },
                            text: isHitApi ? "Loading..." : "Daftar",
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
                            Text('Sudah Memiliki akun?'),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
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
    );
  }
}
