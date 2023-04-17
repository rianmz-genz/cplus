import 'dart:async';

import 'package:calegplus/components/TopBar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../components/DppsSearchedCard.dart';
import '../../components/helper.dart';
import '../../theme/theme.dart';
import '../api/api.dart';
import '../datadpt/detaildpt.dart';
import 'detailsearch.dart';

class Search extends StatefulWidget {
  Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var search = TextEditingController();
  bool isSearching = false;
  bool isWrong = false;
  bool isAfterSearch = false;
  List<dynamic> dpps = [];
  processSearchDptByName() async {
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
    String fixUrl = "${searchDptOnlyName}name=${search.text}";
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
          search.text = "";
          if (responseMap.length == 0) {
            return setState(() {
              isWrong = true;
              search.text = "";
              isSearching = false;
              dpps = responseMap;
            });
          }
          // resNIK = responseMap['nik'];
          // resName = responseMap['name'];
          isWrong = false;
          dpps = responseMap;
          isSearching = false;
          isAfterSearch = true;
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
                          "Pencarian",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize.bigTitle1),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        TextField(
                          controller: search,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              hintText: "Cari nama di DPT",
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    if (search.text.length <= 2) {
                                      return;
                                    }
                                    processSearchDptByName();
                                  },
                                  icon: Icon(Icons.search))),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: isSearching ? Text("Loading...") : null,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: isWrong ? Text("Data tidak ditemukan.") : null,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: isAfterSearch
                              ? Text("${dpps.length} Data ditemukan.")
                              : null,
                        ),
                        ListView.builder(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: dpps.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailSearch(
                                                  tps: dpps[index]['tps']
                                                      ?['name'],
                                                  resFotoKk: dpps[index]
                                                      ['photo_KK'],
                                                  usia:
                                                      "${dpps[index]['usia']} Tahun",
                                                  alamat:
                                                      "${dpps[index]['address']}, RT ${dpps[index]['rt']} RW ${dpps[index]['rw']}",
                                                  disabilitas: dpps[index]
                                                      ['disability'],
                                                  jeniskelamin: dpps[index]
                                                      ['gender'],
                                                  keterangan: dpps[index]
                                                      ['keterangan'],
                                                  namalengkap: dpps[index]
                                                      ['name'],
                                                  resFotoKtp: dpps[index]
                                                      ['photo_KTP'],
                                                  resName: dpps[index]['name'],
                                                  statusperkawinan: dpps[index]
                                                      ['marital_status'],
                                                  tanggallahir: dpps[index]
                                                      ['dob'],
                                                  tempatlahir: dpps[index]
                                                      ['dob_place'],
                                                )));
                                  },
                                  child: Card(
                                    color: dpps[index]['is_check'] == null
                                        ? Colors.grey.shade100
                                        : Colors.orange.shade100
                                            .withOpacity(0.8),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 18),
                                      trailing:
                                          Icon(Icons.chevron_right_outlined),
                                      title: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                  child: Text(
                                                      "${dpps[index]['tps']?['name']} - ${dpps[index]['address']}, RT ${dpps[index]['rt']} RW ${dpps[index]['rw']}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: FontSize
                                                              .subtitle)))
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                  child: Text(
                                                dpps[index]['name'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: FontSize.title,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                  child: Text(
                                                      "${dpps[index]['usia']} Tahun",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: FontSize
                                                              .subtitle)))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                            }),
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}
