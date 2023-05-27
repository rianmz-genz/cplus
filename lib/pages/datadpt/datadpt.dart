import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:calegplus/components/Input.dart';
import 'package:calegplus/components/Navbar.dart';
import 'package:calegplus/pages/datadpt/detaildpt.dart';
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

import '../../components/DppsSearchedCard.dart';
import '../../components/Dropdown.dart';
import '../../components/ProfileItem.dart';
import '../../components/TitleCard.dart';
import '../../components/TopBar.dart';
import '../../components/UploadFile.dart';
import '../../components/helper.dart';
import '../../theme/theme.dart';
import '../api/api.dart';

class DataDpt extends StatefulWidget {
  const DataDpt({super.key});

  @override
  State<DataDpt> createState() => _DataDptState();
}

class _DataDptState extends State<DataDpt> {
  SharedPreferences? prefs;
  @override
  void initState() {
    super.initState();
    getKecamatanToTps();
    printttt();
  }

  printttt() async {
    prefs = await SharedPreferences.getInstance();
    print(prefs?.getString("token"));
  }

  String fotoKtpNameKonfirmasi = "Tidak Ada File";
  String fotoKtpKonfirmasiBase64 = "";
  String fotoKkKonfirmasiBase64 = "";
  String fotoKkKonfirmasiName = "Tidak Ada File";
  String fotoKtpBase64 = "";
  String fotoKkBase64 = "";
  String fotoKtpName = "Tidak Ada File";
  String fotoKKName = "Tidak Ada File";
  bool isAdd = false;
  bool isWrong = false;
  bool isSearching = false;
  bool isAfterSearch = false;
  var noKK = TextEditingController();
  var PHONE = TextEditingController();
  var NIK = TextEditingController();
  var NIKKonfirmasi = TextEditingController();
  var NamaLengkap = TextEditingController();
  var NamaLengkapKonfirmasi = TextEditingController();
  var TempatLahir = TextEditingController();
  var TglLahir = TextEditingController();
  var BlnLahir = TextEditingController();
  var domisili = TextEditingController();
  var rt = TextEditingController();
  var rw = TextEditingController();
  var rtKonfirmasi = TextEditingController();
  var rwKonfirmasi = TextEditingController();
  var ket = TextEditingController();
  String namalengkap = "";
  String tempatlahir = "";
  String tanggallahir = "";
  String statusperkawinan = "";
  String jeniskelamin = "";
  String alamat = "";
  String disabilitas = "";
  String resNIK = "";
  String resName = "";
  String resFotoKtp = "";
  String resFotoKk = "";
  int desaId = 0;
  List<dynamic> getKecamatan = [];
  List<dynamic> getDesa = [];
  List<dynamic> getTps = [];
  List<String> gender = ["Jenis Kelamin", "Laki - laki", "Perempuan"];
  List<String> kecamatanList = ['Kecamatan'];
  List<String> desaList = ['Desa'];
  List<String> tpsList = ['Tps'];
  List<String> married = [
    "Status Perkawinan",
    "Belum Kawin",
    "Kawin",
    "Sudah Kawin"
  ];
  List<String> disability = [
    "Bukan Disabilitas",
    "Tuna Daksa",
    "Tuna Netra",
    "Tuna Rungu/Wicara",
    "Tuna Grahita",
    "Disabilitas Lainnya"
  ];
  String genderValue = "Jenis Kelamin";
  String marriedValue = "Status Perkawinan";
  String disabilityValue = "Bukan Disabilitas";
  String kecamatanValue = "Kecamatan";
  String desaValue = "Desa";
  String tpsValue = "Tps";
  String tpsId = "";
  String keterangan = "";
  List<dynamic> dpps = [];
  processSearchDptByNikAndName() async {
    setState(() {
      isSearching = true;
    });
    int prosesLoading = 0;
    int prosesLoadingRec = 0;
    Response? response;
    Dio().options.receiveTimeout = Duration(milliseconds: 8000);
    Dio().options.connectTimeout = Duration(milliseconds: 8000);
    // if (kDebugMode) {
    //   print("object");
    // }
    String fixUrl =
        "${searchDptByParams}name=${NamaLengkapKonfirmasi.text}&desa_id=${desaId}&rt=${rtKonfirmasi.text}&rw=${rwKonfirmasi.text}";
    try {
      response = await Dio().get(
        fixUrl,
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
      if (kDebugMode) {
        // print("responseMap = ${response?.data['uid']}");
      }
      if (response?.statusCode == 200) {
        var responseMap = response?.data['data'];
        setState(() {
          print("responseMap = $responseMap");
          print(fixUrl);
          NIKKonfirmasi.text = "";
          NamaLengkapKonfirmasi.text = "";
          rtKonfirmasi.text = "";
          rwKonfirmasi.text = "";
          if (responseMap.length == 0) {
            return setState(() {
              isWrong = true;
              NIKKonfirmasi.text = "";
              NamaLengkapKonfirmasi.text = "";
              isSearching = false;
              dpps = responseMap;
            });
          }
          // resNIK = responseMap['nik'];
          // resName = responseMap['name'];
          isWrong = false;
          dpps = responseMap;

          isAfterSearch = true;
          // provinsiList.add(provinsi);
          // resFotoKtp = responseMap['photo_KTP'] ?? "";
          // resFotoKk = responseMap['photo_KK'] ?? "";
          // namalengkap = responseMap['name'] ?? "-";
          // tempatlahir = responseMap['dob_place'] ?? "-";
          // tanggallahir = responseMap['dob'] ?? "-";
          // statusperkawinan = responseMap['marital_status'] ?? "-";
          // jeniskelamin = responseMap['gender'] ?? "-";
          // alamat = responseMap['address'] ?? "-";
          // print(responseMap['address']);
          // keterangan = responseMap['keterangan'];
          // disabilitas = responseMap['disability'] ?? "-";
          // fotoKtpKonfirmasiBase64 = responseMap['photo_KTP'] ?? "";
          // fotoKkKonfirmasiBase64 = responseMap['photo_KK'] ?? "";
          isSearching = false;
        });
        Timer(Duration(milliseconds: 1000), () async {});
      } else if (response?.statusCode == 400) {
        var responseMap = response?.data;
        setState(() {
          isSearching = false;
        });
        betterShowMessage(
            title: '', content: Text(responseMap['message']), context: context);
      } else if (response != null) {
        setState(() {
          isSearching = false;
        });
        betterShowMessage(
            title: '',
            content: const Text(
                'Terjadi kesalahan, silahkan coba beberapa saat lagi'),
            context: context);
        print(response.data);
      }
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

  getStatusPerkawinan() {
    switch (statusperkawinan) {
      case 'S':
        return "Kawin";
      case 'B':
        return "Belum Kawin";
      case 'P':
        return "Sudah Kawin";
      default:
        return 'Status Perkawinan';
    }
  }

  getJenisKelamin() {
    switch (jeniskelamin) {
      case 'L':
        return "Laki-Laki";
      case 'P':
        return "Perempuan";
      default:
        return 'Jenis Kelamin';
    }
  }

  getDisabilitas() {
    switch (disabilitas) {
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
        return 'Bukan Disabilitas';
    }
  }

  getFotoKtpFromGallery() async {
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
              fotoKtpBase64 = base64Encode(bytes);
              print(fotoKtpBase64);
            })
          });
      setState(() {
        fotoKtpName = pickedFile.name;
      });
    } else {
      print("null");
    }
  }

  getFotoKtpFromCamera() async {
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
              fotoKtpBase64 = base64Encode(bytes);
              print(fotoKtpBase64);
            })
          });
      setState(() {
        fotoKtpName = pickedFile.name;
      });
    } else {
      print("null");
    }
  }

  getFotoKKFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final imageTemp = File(pickedFile.path);
      testCompressAndGetFileKtp(imageTemp).then((value) => {
            setState(() {
              final bytes = File(value.path).readAsBytesSync();
              fotoKkBase64 = base64Encode(bytes);
              print(fotoKkBase64);
            })
          });
      setState(() {
        fotoKKName = pickedFile.name;
      });
    }
  }

  getFotoKKFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      final imageTemp = File(pickedFile.path);
      testCompressAndGetFileKtp(imageTemp).then((value) => {
            setState(() {
              final bytes = File(value.path).readAsBytesSync();
              fotoKkBase64 = base64Encode(bytes);
              print(fotoKkBase64);
            })
          });
      setState(() {
        fotoKKName = pickedFile.name;
      });
    }
  }

  processCreateDpp() async {
    setState(() {
      isSearching = true;
    });
    var disabilitySend =
        disability.indexWhere((element) => element == disabilityValue);
    marriedSend() {
      switch (marriedValue) {
        case "Belum Kawin":
          return "B";
        case "Kawin":
          return "S";
        case "Sudah Kawin":
          return "P";
        default:
          return null;
      }
    }

    genderSend() {
      switch (genderValue) {
        case "Laki - laki":
          return "L";
        case "Perempuan":
          return "P";
        default:
          return null;
      }
    }

    String nokkF = "${noKK.text}******";
    String nikF = "${NIK.text}******";
    String fullnameF = "${NamaLengkap.text}";
    String placeBodF = "${TempatLahir.text}";
    String marriedF = "${marriedSend()}";
    String genderF = "${genderSend()}";
    String disabilityF = "${disabilitySend}";
    String dob = "${TglLahir.text} | ${BlnLahir.text}";
    final bodyy = json.encode({
      "no_KK": null,
      "nik": null,
      "name": fullnameF,
      "dob": dob,
      "tps_id": null,
      "rt": rt.text,
      "rw": rw.text,
      "usia": 0,
      "dob_place": placeBodF,
      "marital_status": marriedF,
      "phone": PHONE.text,
      "gender": genderF,
      "address": desaValue,
      "disabilty": null,
      "keterangan": "",
      "photo_KK": fotoKkBase64.isEmpty ? null : fotoKkBase64,
      "photo_KTP": fotoKtpBase64
    });
    prefs = await SharedPreferences.getInstance();
    int prosesLoading = 0;
    int prosesLoadingRec = 0;
    Response? response;
    // if (kDebugMode) {
    //   print("object");
    // }
    print(nokkF);
    print(nikF);
    print(fullnameF);
    print(placeBodF);
    print(marriedF);
    print(genderF);
    print(disabilityF);
    print(fotoKtpBase64);
    print(bodyy);
    try {
      response = await Dio().post(
        urlCreateDpp,
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
      EasyLoading.showError('Tambah Data Dpt Gagal!');
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
          isSearching = false;
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
          isSearching = false;
        });
        betterShowMessage(
            title: 'Tambah Data Dpt Gagal',
            content: Text(responseMap['message']),
            context: context);
      } else if (response != null) {
        var msg = response.data['message'];
        setState(() {
          isSearching = false;
        });
        betterShowMessage(
            title: 'Tambah Data Dpt Gagal',
            content: Text('${msg}'),
            context: context);
        print(response.data);
      }
    }
  }

  getKecamatanToTps() async {
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
        urlGetKecamatanTps,
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
      if (response?.statusCode == 200) {
        var responseMap = response?.data['data'];
        setState(() {
          print("responseMap = $responseMap");
          // provinsiList.add(provinsi);

          for (var res in responseMap) {
            setState(() {
              getKecamatan = responseMap;
              kecamatanList.add(res['name']);
            });
          }
          print(kecamatanList);
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

  getDesaToTps(int id) async {
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
        "${urlGetDesaTps}/${id}",
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
      if (response?.statusCode == 200) {
        var responseMap = response?.data['data'];
        setState(() {
          print("responseMap = $responseMap");
          // provinsiList.add(provinsi);

          for (var res in responseMap) {
            setState(() {
              getDesa = responseMap;
              desaList.add(res['name']);
            });
          }
          print(desaList);
        });
        Timer(Duration(milliseconds: 1000), () async {
          setState(() {});
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

  getDataTps(int id) async {
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
        "${urlGetDataTps}/${id}",
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
      if (response?.statusCode == 200) {
        var responseMap = response?.data['data'];
        setState(() {
          print("responseMap = $responseMap");
          // provinsiList.add(provinsi);

          for (var res in responseMap) {
            setState(() {
              getTps = responseMap;
              tpsList.add(res['name']);
            });
          }
          print(tpsList);
        });
        Timer(Duration(milliseconds: 1000), () async {
          setState(() {});
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
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // button togle
                        Text(
                          "Data DPT",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize.bigTitle1),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8)),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isAdd = false;
                                      print(fotoKtpBase64);
                                      print(fotoKtpKonfirmasiBase64);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                                    decoration: BoxDecoration(
                                        color: isAdd
                                            ? Colors.grey.shade100
                                            : Colors.orange.shade400,
                                        borderRadius: BorderRadius.circular(8)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Konfirmasi DPT",
                                      style: TextStyle(
                                          fontWeight: isAdd
                                              ? FontWeight.normal
                                              : FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isAdd = true;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                                    decoration: BoxDecoration(
                                        color: isAdd
                                            ? Colors.orange.shade400
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Data Baru",
                                      style: TextStyle(
                                          fontWeight: isAdd
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // form
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                          child: isAdd
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // InputText(
                                    //     color: Colors.grey.shade100,
                                    //     title: "No. KK*",
                                    //     placeholder:
                                    //         "Masukan 10 digit awal no KK",
                                    //     type: TextInputType.number,
                                    //     maxLength: 10,
                                    //     controller: noKK),
                                    // InputText(
                                    //     color: Colors.grey.shade100,
                                    //     title: "NIK*",
                                    //     maxLength: 10,
                                    //     placeholder: "Masukan 10 digit no NIK",
                                    //     type: TextInputType.number,
                                    //     controller: NIK),
                                    TitleCard(
                                      icon: Icon(Icons.account_box_outlined),
                                      title: "Data Diri",
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    InputText(
                                        color: Colors.grey.shade100,
                                        title: "Nama Lengkap*",
                                        placeholder: "Masukan nama lengkap",
                                        type: TextInputType.text,
                                        controller: NamaLengkap),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Jenis Kelamin*",
                                              style: TextStyle(
                                                  color: AppColors.textBlack,
                                                  fontSize: FontSize.title),
                                            )),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Status Kawin*",
                                              style: TextStyle(
                                                  color: AppColors.textBlack,
                                                  fontSize: FontSize.title),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Dropdown(
                                            dropdownValue: genderValue,
                                            onChange: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {
                                                if (value! == "Jawa Tengah") {
                                                  print("jawa");
                                                }
                                                genderValue = value;
                                              });
                                            },
                                            color: Colors.grey.shade100,
                                            list: gender,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Dropdown(
                                            onChange: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {
                                                marriedValue = value!;
                                              });
                                            },
                                            dropdownValue: marriedValue,
                                            color: Colors.grey.shade100,
                                            list: married,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              "Tempat Lahir*",
                                              style: TextStyle(
                                                  color: AppColors.textBlack,
                                                  fontSize: FontSize.title),
                                            )),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Tgl lahir*",
                                              style: TextStyle(
                                                  color: AppColors.textBlack,
                                                  fontSize: FontSize.title),
                                            )),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Bln lahir*",
                                              style: TextStyle(
                                                  color: AppColors.textBlack,
                                                  fontSize: FontSize.title),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: TempatLahir,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10),
                                                fillColor: Colors.grey.shade100,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        BorderSide.none),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        BorderSide.none),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        BorderSide.none),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                    borderSide: BorderSide.none),
                                                disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                                hintText: "Sesuai KTP",
                                                hintStyle: TextStyle(fontSize: FontSize.subtitle)),
                                          ),
                                          flex: 2,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: TglLahir,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10),
                                                fillColor: Colors.grey.shade100,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        BorderSide.none),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        BorderSide.none),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        BorderSide.none),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                    borderSide: BorderSide.none),
                                                disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                                hintText: "Cth: 12",
                                                hintStyle: TextStyle(fontSize: FontSize.subtitle)),
                                          ),
                                          flex: 1,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: BlnLahir,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10),
                                                fillColor: Colors.grey.shade100,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        BorderSide.none),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        BorderSide.none),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        BorderSide.none),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                    borderSide: BorderSide.none),
                                                disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                                hintText: "Cth: 08",
                                                hintStyle: TextStyle(fontSize: FontSize.subtitle)),
                                          ),
                                          flex: 1,
                                        )
                                      ],
                                    ),

                                    SizedBox(
                                      height: 24,
                                    ),
                                    TitleCard(
                                      icon: Icon(Icons.map),
                                      title: "Data Domisili",
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Kecamatan*",
                                      style: TextStyle(
                                          color: AppColors.textBlack,
                                          fontSize: FontSize.title),
                                    ),
                                    Dropdown(
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.grey.shade100,
                                      dropdownValue: kecamatanValue,
                                      list: kecamatanList,
                                      onChange: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          kecamatanValue = value!;
                                          print(value);
                                          var filtered = getKecamatan
                                              .where((element) =>
                                                  element['name'] ==
                                                  kecamatanValue)
                                              .toList();
                                          var idcurrent = filtered[0]['id'];
                                          if (desaValue != "Desa") {
                                            desaValue = "Desa";
                                          }
                                          desaList.clear();
                                          desaList.add("Desa");

                                          // tpsList.clear();
                                          // tpsList.add("Tps");
                                          // tpsValue = "Tps";
                                          getDesaToTps(idcurrent);
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "Desa*",
                                      style: TextStyle(
                                          color: AppColors.textBlack,
                                          fontSize: FontSize.title),
                                    ),
                                    Dropdown(
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.grey.shade100,
                                      dropdownValue: desaValue,
                                      list: desaList,
                                      onChange: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          desaValue = value!;

                                          var filtered = getDesa
                                              .where((element) =>
                                                  element['name'] == desaValue)
                                              .toList();
                                          var idcurrent = filtered[0]['id'];
                                          // tpsList.clear();
                                          // tpsList.add("Tps");
                                          // getDataTps(idcurrent);
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        // Expanded(
                                        //     flex: 2,
                                        //     child: Text(
                                        //       "Domsili(dukuh)*",
                                        //       style: TextStyle(
                                        //           color: AppColors.textBlack,
                                        //           fontSize: FontSize.title),
                                        //     )),
                                        // SizedBox(
                                        //   width: 4,
                                        // ),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Rt*",
                                              style: TextStyle(
                                                  color: AppColors.textBlack,
                                                  fontSize: FontSize.title),
                                            )),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Rw*",
                                              style: TextStyle(
                                                  color: AppColors.textBlack,
                                                  fontSize: FontSize.title),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        // Expanded(
                                        //   child: TextField(
                                        //     controller: domisili,
                                        //     keyboardType: TextInputType.text,
                                        //     decoration: InputDecoration(
                                        //         contentPadding:
                                        //             EdgeInsets.symmetric(
                                        //                 vertical: 5,
                                        //                 horizontal: 10),
                                        //         fillColor: Colors.grey.shade100,
                                        //         border: OutlineInputBorder(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(15),
                                        //             borderSide: BorderSide.none),
                                        //         focusedBorder: OutlineInputBorder(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(15),
                                        //             borderSide: BorderSide.none),
                                        //         enabledBorder: OutlineInputBorder(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(15),
                                        //             borderSide: BorderSide.none),
                                        //         errorBorder: OutlineInputBorder(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(15),
                                        //             borderSide: BorderSide.none),
                                        //         disabledBorder:
                                        //             OutlineInputBorder(
                                        //                 borderRadius:
                                        //                     BorderRadius.circular(
                                        //                         15),
                                        //                 borderSide:
                                        //                     BorderSide.none),
                                        //         hintText: "Domisili",
                                        //         hintStyle: TextStyle(
                                        //             fontSize: FontSize.subtitle)),
                                        //   ),
                                        //   flex: 2,
                                        // ),
                                        // SizedBox(
                                        //   width: 4,
                                        // ),
                                        Expanded(
                                          child: TextField(
                                            controller: rt,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10),
                                                fillColor: Colors.grey.shade100,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        BorderSide.none),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        BorderSide.none),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        BorderSide.none),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                    borderSide: BorderSide.none),
                                                disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                                hintText: "Cth: 008",
                                                hintStyle: TextStyle(fontSize: FontSize.subtitle)),
                                          ),
                                          flex: 1,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: rw,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10),
                                                fillColor: Colors.grey.shade100,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        BorderSide.none),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        BorderSide.none),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    borderSide:
                                                        BorderSide.none),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                    borderSide: BorderSide.none),
                                                disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                                hintText: "Cth: 009",
                                                hintStyle: TextStyle(fontSize: FontSize.subtitle)),
                                          ),
                                          flex: 1,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 24,
                                    ),

                                    // SizedBox(
                                    //   height: 8,
                                    // ),
                                    // Text(
                                    //   "Tps*",
                                    //   style: TextStyle(
                                    //       color: AppColors.textBlack,
                                    //       fontSize: FontSize.title),
                                    // ),
                                    // Dropdown(
                                    //   width: MediaQuery.of(context).size.width,
                                    //   color: Colors.grey.shade100,
                                    //   dropdownValue: tpsValue,
                                    //   list: tpsList,
                                    //   onChange: (String? value) {
                                    //     // This is called when the user selects an item.
                                    //     setState(() {
                                    //       tpsValue = value!;

                                    //       var filtered = getTps
                                    //           .where((element) =>
                                    //               element['name'] == tpsValue)
                                    //           .toList();
                                    //       var idcurrent = filtered[0]['id'];
                                    //       tpsId = "${idcurrent}";
                                    //       print(tpsId);
                                    //       // tpsList.clear();
                                    //       // tpsList.add("Tps");
                                    //       // getDataTps(idcurrent);
                                    //     });
                                    //   },
                                    // ),
                                    // SizedBox(
                                    //   height: 8,
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //         flex: 1,
                                    //         child: Text(
                                    //           "Disabilitas*",
                                    //           style: TextStyle(
                                    //               color: AppColors.textBlack,
                                    //               fontSize: FontSize.title),
                                    //         )),
                                    //   ],
                                    // ),
                                    // SizedBox(
                                    //   height: 4,
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       flex: 1,
                                    //       child: Dropdown(
                                    //         dropdownValue: disabilityValue,
                                    //         onChange: (String? value) {
                                    //           // This is called when the user selects an item.
                                    //           setState(() {
                                    //             if (value! == "Jawa Tengah") {
                                    //               print("jawa");
                                    //             }
                                    //             disabilityValue = value;
                                    //           });
                                    //         },
                                    //         color: Colors.grey.shade100,
                                    //         list: disability,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // SizedBox(
                                    //   height: 8,
                                    // ),
                                    TitleCard(
                                      icon: Icon(Icons.book),
                                      title: "Data Pelengkap",
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Upload Foto KK(Opsional)",
                                              style: TextStyle(
                                                  color: AppColors.textBlack,
                                                  fontSize: FontSize.title),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    UploadFile(
                                      color: Colors.grey.shade100,
                                      fileName: fotoKKName,
                                      onClick: () {
                                        betterShowMessage(
                                            title: 'Pilih metode',
                                            content: Text(''),
                                            onDefaultX: true,
                                            buttons: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 60,
                                                    child: GFButton(
                                                      onPressed: () {
                                                        getFotoKKFromGallery();
                                                        Navigator.pop(context);
                                                      },
                                                      text: "Dari Gallery",
                                                      color: AppColors.primary,
                                                      textStyle: GoogleFonts
                                                          .plusJakartaSans(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                      size: GFSize.LARGE,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 60,
                                                    child: GFButton(
                                                      onPressed: () {
                                                        getFotoKKFromCamera();
                                                        Navigator.pop(context);
                                                      },
                                                      text: "Dari Kamera",
                                                      color: AppColors.primary,
                                                      textStyle: GoogleFonts
                                                          .plusJakartaSans(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Upload Foto KTP*",
                                              style: TextStyle(
                                                  color: AppColors.textBlack,
                                                  fontSize: FontSize.title),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    UploadFile(
                                      color: Colors.grey.shade100,
                                      fileName: fotoKtpName,
                                      onClick: () {
                                        betterShowMessage(
                                            title: 'Pilih metode',
                                            content: Text(''),
                                            onDefaultX: true,
                                            buttons: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 60,
                                                    child: GFButton(
                                                      onPressed: () {
                                                        getFotoKtpFromGallery();
                                                        Navigator.pop(context);
                                                      },
                                                      text: "Dari Gallery",
                                                      color: AppColors.primary,
                                                      textStyle: GoogleFonts
                                                          .plusJakartaSans(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                      size: GFSize.LARGE,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 60,
                                                    child: GFButton(
                                                      onPressed: () {
                                                        getFotoKtpFromCamera();
                                                        Navigator.pop(context);
                                                      },
                                                      text: "Dari Kamera",
                                                      color: AppColors.primary,
                                                      textStyle: GoogleFonts
                                                          .plusJakartaSans(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                      size: GFSize.LARGE,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                            context: context);
                                      },
                                    ),
                                    SizedBox(height: 8),
                                    Row(children: [
                                      Flexible(
                                          child: Text(
                                        "Nomor Telepon*",
                                        style: TextStyle(
                                            color: AppColors.textBlack,
                                            fontSize: FontSize.title),
                                      ))
                                    ]),
                                    SizedBox(height: 4),
                                    TextField(
                                      controller: PHONE,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          fillColor: Colors.grey.shade100,
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
                                          hintText: "Cth: 082589877654",
                                          hintStyle: TextStyle(
                                              fontSize: FontSize.subtitle)),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      width: MediaQuery.of(context).size.width,
                                      height: 60,
                                      child: GFButton(
                                        onPressed: () {
                                          var jkIndex = gender.indexWhere(
                                              (element) =>
                                                  element == genderValue);
                                          var skIndex = married.indexWhere(
                                              (element) =>
                                                  element == marriedValue);
                                          if (NamaLengkap.text.isEmpty ||
                                              desaValue == "Desa" ||
                                              jkIndex == 0 ||
                                              skIndex == 0 ||
                                              TempatLahir.text.isEmpty ||
                                              rt.text.isEmpty ||
                                              rw.text.isEmpty ||
                                              TglLahir.text.isEmpty ||
                                              PHONE.text.isEmpty ||
                                              BlnLahir.text.isEmpty) {
                                            betterShowMessage(
                                                context: context,
                                                title: "",
                                                content: Text(
                                                    "Harap isi field terlebih dahulu."));
                                            return;
                                          }
                                          if (TglLahir.text.length > 2 ||
                                              BlnLahir.text.length > 2) {
                                            betterShowMessage(
                                                context: context,
                                                title: "",
                                                content: Text(
                                                    "Tanggal lahir atau bulan lahir tidak sesuai format, isi 2 karakter saja!"));
                                            return;
                                          }
                                          if (rt.text.length > 3 ||
                                              rw.text.length > 3) {
                                            betterShowMessage(
                                                context: context,
                                                title: "",
                                                content: Text(
                                                    "Rt atau rw tidak sesuai format, harus 3 karakter!"));
                                            return;
                                          }
                                          if (fotoKtpBase64.isEmpty) {
                                            betterShowMessage(
                                                context: context,
                                                title: "",
                                                content: Text(
                                                    "Upload foto KTP terlebih dahulu!"));
                                            return;
                                          }
                                          processCreateDpp();
                                        },
                                        text: isSearching
                                            ? "Loading..."
                                            : "Tambah Dpt",
                                        color: AppColors.primary,
                                        textStyle: GoogleFonts.plusJakartaSans(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        size: GFSize.LARGE,
                                        shape: GFButtonShape.pills,
                                        icon: Icon(
                                          isSearching
                                              ? Icons.cached_sharp
                                              : Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    )
                                  ],
                                )
                              // konfirmasi
                              : Column(
                                  children: [
                                    Container(
                                      child: isAfterSearch
                                          ? SizedBox()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Kecamatan*",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.textBlack,
                                                      fontSize: FontSize.title),
                                                ),
                                                Dropdown(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  color: Colors.grey.shade100,
                                                  dropdownValue: kecamatanValue,
                                                  list: kecamatanList,
                                                  onChange: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      kecamatanValue = value!;
                                                      print(value);
                                                      var filtered = getKecamatan
                                                          .where((element) =>
                                                              element['name'] ==
                                                              kecamatanValue)
                                                          .toList();
                                                      var idcurrent =
                                                          filtered[0]['id'];
                                                      if (desaValue != "Desa") {
                                                        desaValue = "Desa";
                                                      }
                                                      desaList.clear();
                                                      desaList.add("Desa");

                                                      tpsValue = "Tps";
                                                      getDesaToTps(idcurrent);
                                                    });
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  "Desa*",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.textBlack,
                                                      fontSize: FontSize.title),
                                                ),
                                                Dropdown(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  color: Colors.grey.shade100,
                                                  dropdownValue: desaValue,
                                                  list: desaList,
                                                  onChange: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      desaValue = value!;

                                                      var filtered = getDesa
                                                          .where((element) =>
                                                              element['name'] ==
                                                              desaValue)
                                                          .toList();
                                                      var idcurrent =
                                                          filtered[0]['id'];
                                                      desaId = idcurrent;
                                                      print(idcurrent);
                                                    });
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                InputText(
                                                    color: Colors.grey.shade100,
                                                    title: "Nama Lengkap*",
                                                    colorMaxLength:
                                                        Colors.black,
                                                    placeholder:
                                                        "Masukan Nama Lengkap",
                                                    type: TextInputType.text,
                                                    controller:
                                                        NamaLengkapKonfirmasi),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        children: [
                                                          InputText(
                                                              color: Colors.grey
                                                                  .shade100,
                                                              title: "RT*",
                                                              colorMaxLength:
                                                                  Colors.black,
                                                              placeholder:
                                                                  "cth: 009",
                                                              type:
                                                                  TextInputType
                                                                      .number,
                                                              maxLength: 3,
                                                              controller:
                                                                  rtKonfirmasi),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Column(
                                                        children: [
                                                          InputText(
                                                              color: Colors.grey
                                                                  .shade100,
                                                              title: "RW*",
                                                              placeholder:
                                                                  "cth: 004",
                                                              type:
                                                                  TextInputType
                                                                      .number,
                                                              maxLength: 3,
                                                              colorMaxLength:
                                                                  Colors.black,
                                                              controller:
                                                                  rwKonfirmasi),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 55,
                                                    child: isAfterSearch
                                                        ? null
                                                        : GFButton(
                                                            onPressed: () {
                                                              if (desaValue ==
                                                                  "Desa") {
                                                                betterShowMessage(
                                                                    title: '',
                                                                    content:
                                                                        const Text(
                                                                            'Harap pilih Desa terlebih dahulu!'),
                                                                    context:
                                                                        context);
                                                                return;
                                                              }
                                                              if (rtKonfirmasi
                                                                      .text
                                                                      .isEmpty ||
                                                                  rwKonfirmasi
                                                                      .text
                                                                      .isEmpty) {
                                                                betterShowMessage(
                                                                    title: '',
                                                                    content:
                                                                        const Text(
                                                                            'RT atau RW tidak boleh kosong'),
                                                                    context:
                                                                        context);
                                                                return;
                                                              }
                                                              if (NamaLengkapKonfirmasi
                                                                  .text
                                                                  .isEmpty) {
                                                                betterShowMessage(
                                                                    title: '',
                                                                    content:
                                                                        const Text(
                                                                            'Nama tidak boleh kosong'),
                                                                    context:
                                                                        context);
                                                                return;
                                                              }
                                                              if (isSearching ==
                                                                  true) {
                                                                return;
                                                              }
                                                              processSearchDptByNikAndName();
                                                            },
                                                            text: isSearching
                                                                ? "Loading"
                                                                : "Cari Data",
                                                            color: AppColors
                                                                .primary,
                                                            textStyle: GoogleFonts
                                                                .plusJakartaSans(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            size: GFSize.LARGE,
                                                            shape: GFButtonShape
                                                                .pills,
                                                            icon: Icon(
                                                              isSearching
                                                                  ? Icons
                                                                      .recycling
                                                                  : Icons
                                                                      .search,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ))
                                              ],
                                            ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      child: isAfterSearch
                                          ? Column(
                                              children: [
                                                Text(
                                                    "${dpps.length} Data ditemukan."),
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.all(0),
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: dpps.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          DetailDpt(
                                                                            tps:
                                                                                dpps[index]['tps']['name'],
                                                                            resFotoKk:
                                                                                dpps[index]['photo_KK'],
                                                                            usia:
                                                                                dpps[index]['usia'],
                                                                            alamat:
                                                                                "${dpps[index]['address']}, RT${dpps[index]['rt']}/RW${dpps[index]['rw']}",
                                                                            disabilitas:
                                                                                dpps[index]['disability'],
                                                                            jeniskelamin:
                                                                                dpps[index]['gender'],
                                                                            keterangan:
                                                                                dpps[index]['keterangan'],
                                                                            namalengkap:
                                                                                dpps[index]['name'],
                                                                            resFotoKtp:
                                                                                dpps[index]['photo_KTP'],
                                                                            resName:
                                                                                dpps[index]['name'],
                                                                            statusperkawinan:
                                                                                dpps[index]['marital_status'],
                                                                            tanggallahir:
                                                                                dpps[index]['dob'],
                                                                            tempatlahir:
                                                                                dpps[index]['dob_place'],
                                                                          )));
                                                        },
                                                        child: DppsSearchedCard(
                                                          color: dpps[index][
                                                                      'is_check'] ==
                                                                  null
                                                              ? Colors
                                                                  .grey.shade100
                                                              : Colors.orange
                                                                  .shade100
                                                                  .withOpacity(
                                                                      0.8),
                                                          alamat:
                                                              "${dpps[index]['tps']['name']} - ${dpps[index]['address']}, RT${dpps[index]['rt']}/RW${dpps[index]['rw']}",
                                                          name: dpps[index]
                                                              ['name'],
                                                          usia:
                                                              "${dpps[index]['usia']} Tahun",
                                                        ),
                                                      );
                                                    }),
                                              ],
                                            )
                                          : SizedBox(),
                                    ),
                                    Text(
                                        isWrong ? "Data Tidak ditemukan." : ""),
                                  ],
                                ),
                        )
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}
