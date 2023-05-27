import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:calegplus/components/Navbar.dart';
import 'package:calegplus/pages/home/beranda.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

class DetailSearch extends StatefulWidget {
  DetailSearch(
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
      required this.phone,
      required this.tps,
      required this.resFotoKk});
  var namalengkap;
  var usia;
  var tempatlahir;
  var tanggallahir;
  var alamat;
  var keterangan;
  var statusperkawinan;
  var jeniskelamin;
  var disabilitas;
  var resFotoKtp;
  var resFotoKk;
  var resName;
  var tps;
  var phone;

  @override
  State<DetailSearch> createState() => _DetailSearchState();
}

class _DetailSearchState extends State<DetailSearch> {
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
      quality: 60,
      format: CompressFormat.jpeg,
    );

    print(file.lengthSync());
    print(result!.lengthSync());

    return result;
  }

  Future getFotoKtpKonfirmasiFromGallery() async {
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
              fotoKtpKonfirmasiBase64 = base64Encode(bytes);
              print(fotoKtpKonfirmasiBase64);
            })
          });
      setState(() {
        fotoKtpNameKonfirmasi = pickedFile.name;
      });
    } else {
      print("ksong");
    }
  }

  Future getFotoKkKonfirmasiFromGallery() async {
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

  // processUpdateDpp() async {
  //   final body = json.encode({
  //     'photo_KTP': fotoKtpKonfirmasiBase64,
  //     'photo_KK': fotoKkKonfirmasiBase64,
  //     'keterangan': ket.text
  //   });
  //   prefs = await SharedPreferences.getInstance();
  //   int prosesLoading = 0;
  //   int prosesLoadingRec = 0;
  //   Response? response;
  //   Dio().options.receiveTimeout = Duration(milliseconds: 8000);
  //   Dio().options.connectTimeout = Duration(milliseconds: 8000);
  //   // if (kDebugMode) {
  //   //   print("object");
  //   // }
  //   print(body);
  //   String fixUrl = "${urlUpdateDpp}?&name=${widget.resName}";
  //   try {
  //     response = await Dio().put(
  //       fixUrl,
  //       data: body,
  //       onSendProgress: (int count, int total) {
  //         prosesLoading = (count / total * 100).round();
  //         print("prosesLoading = $prosesLoading");
  //         EasyLoading.show(
  //           status: '$prosesLoading',
  //           maskType: EasyLoadingMaskType.black,
  //         );
  //       },
  //       onReceiveProgress: (int count, int total) {
  //         prosesLoadingRec = (count / total * 100).round();
  //         print("prosesLoading = $prosesLoadingRec");
  //       },
  //       options: Options(
  //           headers: {
  //             HttpHeaders.contentTypeHeader: "application/json",
  //             HttpHeaders.authorizationHeader:
  //                 "Bearer ${prefs!.getString("token")}"
  //           },
  //           receiveTimeout: const Duration(milliseconds: 8000),
  //           sendTimeout: const Duration(milliseconds: 8000)),
  //     );
  //     if (prosesLoading == 100) {
  //       EasyLoading.dismiss();
  //     }
  //   } on DioError catch (e) {
  //     EasyLoading.showError('Tambah Data Dpt Gagal!');
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
  //     if (kDebugMode) {
  //       // print("responseMap = ${response?.data['uid']}");
  //     }
  //     if (response?.statusCode == 200) {
  //       var responseMap = response?.data;
  //       setState(() {
  //         print("responseMap = $responseMap");
  //       });
  //       EasyLoading.showSuccess('Tambah Data Dpt Berhasil!');
  //       Timer(Duration(milliseconds: 1000), () async {
  //         EasyLoading.dismiss();
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => Navbar(
  //                       seciliIndex: 0,
  //                     )));
  //       });
  //     } else if (response?.statusCode == 400) {
  //       var responseMap = response?.data;
  //       betterShowMessage(
  //           title: 'Tambah Data Dpt Gagal',
  //           content: Text(responseMap['message']),
  //           context: context);
  //     } else if (response != null) {
  //       var msg = response.data['message'];
  //       betterShowMessage(
  //           title: 'Tambah Data Dpt Gagal',
  //           content: Text('${msg}'),
  //           context: context);
  //       print(response.data);
  //     }
  //   }
  // }

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
              rightText: widget.usia ?? "-",
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
              rightText: widget.tps ?? "-",
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
            ProfileItem(
              leftText: "Nomor Telepon",
              rightText: widget.phone ?? "-",
            ),
            SizedBox(height: 8),
            // Row(
            //   children: [
            //     Expanded(
            //         flex: 1,
            //         child: Text(
            //           fotoKtpKonfirmasiBase64 == null
            //               ? ""
            //               : "Foto Ktp Terupload.",
            //           style: TextStyle(
            //               color: AppColors.textBlack, fontSize: FontSize.title),
            //         )),
            //   ],
            // ),
            // SizedBox(
            //   height: 4,
            // ),
            // Container(
            //   child: fotoKtpKonfirmasiBase64 == null
            //       ? UploadFile(
            //           color: Colors.grey.shade100,
            //           fileName: fotoKtpNameKonfirmasi,
            //           onClick: () {
            //             getFotoKtpKonfirmasiFromGallery();
            //           },
            //         )
            //       : null,
            // ),
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
              child: fotoKtpKonfirmasiBase64 != null
                  ? Image.memory(base64Decode(fotoKtpKonfirmasiBase64))
                  : null,
            ),
            SizedBox(
              height: 8,
            ),
            // Row(
            //   children: [
            //     Expanded(
            //         flex: 1,
            //         child: Text(
            //           fotoKkKonfirmasiBase64 == null
            //               ? ""
            //               : "Foto Kk Terupload.",
            //           style: TextStyle(
            //               color: AppColors.textBlack, fontSize: FontSize.title),
            //         )),
            //   ],
            // ),
            // SizedBox(
            //   height: 4,
            // ),
            // Container(
            //   child: fotoKkKonfirmasiBase64 == null
            //       ? UploadFile(
            //           color: Colors.grey.shade100,
            //           fileName: fotoKkKonfirmasiName,
            //           onClick: () {
            //             getFotoKkKonfirmasiFromGallery();
            //           },
            //         )
            //       : null,
            // ),
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
                    fotoKtpKonfirmasiBase64 != null
                        ? "Foto KK Terupload"
                        : "Tidak ada foto KK",
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
              child: fotoKkKonfirmasiBase64 != null
                  ? Image.memory(base64Decode(fotoKkKonfirmasiBase64))
                  : null,
            ),
            // SizedBox(height: 8),
            // Container(
            //     child: widget.keterangan.isEmpty
            //         ? InputText(
            //             color: Colors.grey.shade100,
            //             title: "Keterangan",
            //             placeholder: "Masukan Keterangan",
            //             type: TextInputType.text,
            //             controller: ket)
            //         : null),
            SizedBox(height: 16),
            // Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: 55,
            //     child: widget.resFotoKtp == null
            //         ? GFButton(
            //             onPressed: () {
            //               if (ket.text.length <= 3) {
            //                 betterShowMessage(
            //                     context: context,
            //                     title: "",
            //                     content: Text("Keterangan tidak boleh kosong"));
            //                 return;
            //               }
            //               processUpdateDpp();
            //             },
            //             text: "Konfirmasi",
            //             color: AppColors.primary,
            //             textStyle: GoogleFonts.plusJakartaSans(
            //                 fontSize: 16, fontWeight: FontWeight.bold),
            //             size: GFSize.LARGE,
            //             shape: GFButtonShape.pills,
            //             icon: Icon(
            //               Icons.check,
            //               color: Colors.white,
            //             ),
            //           )
            //         : null)
          ],
        ),
      )),
    );
  }
}
