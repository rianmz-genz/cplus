import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:calegplus/components/Navbar.dart';
import 'package:calegplus/pages/home/beranda.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../../components/Dropdown.dart';
import '../../components/Input.dart';
import '../../components/ProfileItem.dart';
import '../../components/TopBar.dart';
import '../../components/UploadFile.dart';
import '../../components/helper.dart';
import '../../theme/theme.dart';
import '../api/api.dart';

class DetailDpt extends StatefulWidget {
  DetailDpt(
      {super.key,
      required this.namalengkap,
      required this.tempatlahir,
      required this.tanggallahir,
      required this.alamat,
      required this.keterangan,
      required this.statusperkawinan,
      required this.jeniskelamin,
      required this.disabilitas,
      required this.resName,
      required this.usia,
      required this.resFotoKtp,
      required this.tps,
      required this.resFotoKk});
  var namalengkap;
  var usia;
  var tempatlahir;
  var tps;
  var tanggallahir;
  var alamat;
  var keterangan;
  var statusperkawinan;
  var jeniskelamin;
  var disabilitas;
  var resFotoKtp;
  var resFotoKk;
  var resName;

  @override
  State<DetailDpt> createState() => _DetailDptState();
}

class _DetailDptState extends State<DetailDpt> {
  SharedPreferences? prefs;
  var fotoKtpKonfirmasiBase64;
  var fotoKkKonfirmasiBase64;
  @override
  void initState() {
    super.initState();
    // getKecamatanToTps();
    setState(() {
      fotoKtpKonfirmasiBase64 = widget.resFotoKtp;
      fotoKkKonfirmasiBase64 = widget.resFotoKk;
    });
  }

  String fotoKtpNameKonfirmasi = "Tidak Ada File";
  String fotoKkKonfirmasiName = "Tidak Ada File";
  var ket = TextEditingController();
  getStatusPerkawinan() {
    switch (widget.statusperkawinan) {
      case 'S':
        return "Kawin";
      case 'B':
        'package:flutter_image_compress/flutter_image_compress.dart';
        return "Belum Kawin";
      case 'P':
        return "Sudah Kawin";
      default:
        return '-';
    }
  }

  getJenisKelamin() {
    switch (widget.jeniskelamin) {
      case 'L':
        return "Laki-Laki";
      case 'P':
        return "Perempuan";
      default:
        return '-';
    }
  }

  getDisabilitas() {
    switch (widget.disabilitas) {
      case '0':
        return "Bukan Disabilitas";
      case '1':
        return "Tuna Daksa";
      case '2':
        return "Tuna Netra";
      case '3':
        return "Tuna Rungu/Wicara";
      case '4':
        return "Tuna Grahita";
      case '5':
        return "Disabilitas Lainnya";
      default:
        return '-';
    }
  }

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

  Future getFotoKtpKonfirmasiFromGallery() async {
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
            fotoKtpKonfirmasiBase64 = base64Encode(bytes);
            print(fotoKtpKonfirmasiBase64);
          });
        });
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future getFotoKtpKonfirmasiFromCamera() async {
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
            fotoKtpKonfirmasiBase64 = base64Encode(bytes);
            print(fotoKtpKonfirmasiBase64);
          });
        });
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future getFotoKkKonfirmasiFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      final imageTemp = File(pickedFile.path);
      testCompressAndGetFileKtp(imageTemp).then((value) => {
            setState(() {
              final bytes = File(value.path).readAsBytesSync();
              fotoKkKonfirmasiBase64 = base64Encode(bytes);
              print(fotoKkKonfirmasiBase64);
            })
          });
      setState(() {
        fotoKkKonfirmasiName = pickedFile.name;
      });
    } else {
      print("ksong");
    }
  }

  Future getFotoKkKonfirmasiFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      final imageTemp = File(pickedFile.path);
      testCompressAndGetFileKtp(imageTemp).then((value) => {
            setState(() {
              final bytes = File(value.path).readAsBytesSync();
              fotoKkKonfirmasiBase64 = base64Encode(bytes);
              print(fotoKkKonfirmasiBase64);
            })
          });
      setState(() {
        fotoKkKonfirmasiName = pickedFile.name;
      });
    } else {
      print("ksong");
    }
  }

  processUpdateDpp() async {
    final body = json.encode({
      'photo_KK': fotoKkKonfirmasiBase64,
      'keterangan': ket.text,
      'photo_KTP': fotoKtpKonfirmasiBase64,
    });
    prefs = await SharedPreferences.getInstance();
    int prosesLoading = 0;
    int prosesLoadingRec = 0;
    Response? response;
    Dio().options.receiveTimeout = Duration(milliseconds: 8000);
    Dio().options.connectTimeout = Duration(milliseconds: 8000);
    // if (kDebugMode) {
    //   print("object");
    // }
    print(body);
    String fixUrl =
        "${urlUpdateDpp}?name=${widget.resName}&usia=${widget.usia}";
    try {
      response = await Dio().put(
        fixUrl,
        data: body,
        onSendProgress: (int count, int total) {
          prosesLoading = (count / total * 100).round();
          print("prosesLoading = $prosesLoading");
          EasyLoading.show(
            status: '$prosesLoading',
            maskType: EasyLoadingMaskType.black,
          );
        },
        onReceiveProgress: (int count, int total) {
          prosesLoadingRec = (count / total * 100).round();
          print("prosesLoading = $prosesLoadingRec");
        },
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader:
                "Bearer ${prefs!.getString("token")}"
          },
        ),
      );
      if (prosesLoading == 100) {
        EasyLoading.dismiss();
      }
    } on DioError catch (e) {
      EasyLoading.showError('Update Data Dpt Gagal!');
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
        print(fixUrl);
        print(body);
        print("Bearer ${prefs!.getString("token")}");
        setState(() {
          print("responseMap = $responseMap");
        });
        if (responseMap == null) {
          betterShowMessage(
              title: 'Update Data Dpt Gagal',
              content: Text("Ukuran gambar terlalu besar."),
              context: context);
          return;
        }
        EasyLoading.showSuccess('Update Data Dpt Berhasil!');
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
        betterShowMessage(
            title: 'Update Data Dpt Gagal',
            content: Text(responseMap['message']),
            context: context);
      } else if (response != null) {
        var msg = response.data['message'];
        betterShowMessage(
            title: 'Update Data Dpt Gagal',
            content: Text('${msg}'),
            context: context);
        print(response.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          "Detail",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.bigTitle2,
              color: Colors.black),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            ProfileItem(
              leftText: "Nama Lengkap",
              rightText: widget.namalengkap ?? "-",
            ),
            SizedBox(height: 8),
            ProfileItem(
              leftText: "Tempat Lahir",
              rightText: widget.tempatlahir ?? "-",
            ),
            SizedBox(height: 8),
            ProfileItem(
              leftText: "Tanggal Lahir",
              rightText: widget.tanggallahir ?? "-",
            ),
            SizedBox(height: 8),
            ProfileItem(
              leftText: "Usia",
              rightText: "${widget.usia ?? "-"} Tahun",
            ),
            SizedBox(height: 8),
            ProfileItem(
              leftText: "Status Perkawinan",
              rightText: getStatusPerkawinan(),
            ),
            SizedBox(height: 8),
            ProfileItem(
              leftText: "Jenis Kelamin",
              rightText: getJenisKelamin(),
            ),
            SizedBox(height: 8),
            ProfileItem(
              leftText: "Alamat",
              rightText: widget.alamat,
            ),
            SizedBox(height: 8),
            ProfileItem(
              leftText: "Tps",
              rightText: widget.tps,
            ),
            SizedBox(height: 8),
            ProfileItem(
              leftText: "Disabilitas",
              rightText: getDisabilitas(),
            ),
            SizedBox(height: 8),
            ProfileItem(
              leftText: "Keterangan",
              rightText: widget.keterangan.isEmpty ? "-" : widget.keterangan,
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
              decoration: BoxDecoration(color: Colors.grey.shade100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: fotoKtpKonfirmasiBase64 != null
                          ? Icon(Icons.check, color: Colors.green)
                          : Icon(Icons.close, color: Colors.red)),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    fotoKtpKonfirmasiBase64 != null
                        ? "Foto KTP Terupload"
                        : "Tidak ada foto KTP",
                    style: TextStyle(
                        color: fotoKtpKonfirmasiBase64 != null
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              child: fotoKtpKonfirmasiBase64 == null
                  ? UploadFile(
                      color: Colors.grey.shade100,
                      fileName: fotoKtpNameKonfirmasi,
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
                                        getFotoKtpKonfirmasiFromGallery();
                                        Navigator.pop(context);
                                      },
                                      text: "Dari Gallery",
                                      color: AppColors.primary,
                                      textStyle: GoogleFonts.plusJakartaSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      size: GFSize.LARGE,
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    child: GFButton(
                                      onPressed: () {
                                        getFotoKtpKonfirmasiFromCamera();
                                        Navigator.pop(context);
                                      },
                                      text: "Dari Kamera",
                                      color: AppColors.primary,
                                      textStyle: GoogleFonts.plusJakartaSans(
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
                    )
                  : null,
            ),
            Container(
              child: fotoKtpKonfirmasiBase64 != null
                  ? Image.memory(base64Decode(fotoKtpKonfirmasiBase64))
                  : null,
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
              decoration: BoxDecoration(color: Colors.grey.shade100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: fotoKkKonfirmasiBase64 != null
                          ? Icon(Icons.check, color: Colors.green)
                          : Icon(Icons.close, color: Colors.red)),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    fotoKkKonfirmasiBase64 != null
                        ? "Foto Kk Terupload"
                        : "Tidak ada foto Kk",
                    style: TextStyle(
                        color: fotoKkKonfirmasiBase64 != null
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              child: fotoKkKonfirmasiBase64 == null
                  ? UploadFile(
                      color: Colors.grey.shade100,
                      fileName: fotoKkKonfirmasiName,
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
                                        getFotoKkKonfirmasiFromGallery();
                                        Navigator.pop(context);
                                      },
                                      text: "Dari Gallery",
                                      color: AppColors.primary,
                                      textStyle: GoogleFonts.plusJakartaSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      size: GFSize.LARGE,
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    child: GFButton(
                                      onPressed: () {
                                        getFotoKkKonfirmasiFromCamera();
                                        Navigator.pop(context);
                                      },
                                      text: "Dari Kamera",
                                      color: AppColors.primary,
                                      textStyle: GoogleFonts.plusJakartaSans(
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
                    )
                  : null,
            ),
            Container(
              child: fotoKkKonfirmasiBase64 != null
                  ? Image.memory(base64Decode(fotoKkKonfirmasiBase64))
                  : null,
            ),
            SizedBox(height: 8),
            Container(
                child: widget.resFotoKtp == null
                    ? InputText(
                        color: Colors.grey.shade100,
                        title: "Keterangan(opsional)",
                        placeholder: "Masukan Keterangan",
                        type: TextInputType.text,
                        controller: ket)
                    : null),
            SizedBox(height: 16),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: widget.resFotoKtp == null
                    ? GFButton(
                        onPressed: () {
                          print(fotoKkKonfirmasiBase64);
                          if (fotoKtpKonfirmasiBase64 == null) {
                            betterShowMessage(
                                title: '',
                                content:
                                    const Text('Harus mengupload foto ktp!'),
                                context: context);
                            return;
                          }
                          processUpdateDpp();
                        },
                        text: "Konfirmasi",
                        color: AppColors.primary,
                        textStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        size: GFSize.LARGE,
                        shape: GFButtonShape.pills,
                        icon: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      )
                    : null)
          ],
        ),
      )),
    );
  }
}
