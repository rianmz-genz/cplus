import 'package:calegplus/pages/datadpt/datadpt.dart';
import 'package:calegplus/pages/home/beranda.dart';
import 'package:calegplus/pages/profile/profile.dart';

import 'package:calegplus/pages/search/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Navbar extends StatefulWidget {
  Navbar({super.key, required this.seciliIndex});

  int seciliIndex;

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late int seciliMenu;

  late List<Widget> calegPage;
  late Beranda beranda;
  late Search search;
  late DataDpt dataDpt;
  late Profile profile;
  @override
  void initState() {
    seciliMenu = widget.seciliIndex;
    super.initState();
    beranda = Beranda();
    search = Search();
    dataDpt = DataDpt();
    profile = Profile();

    calegPage = [beranda, search, dataDpt, profile];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey.shade300,
          type: BottomNavigationBarType.shifting,
          backgroundColor: Colors.orange.shade900,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Beranda",
              backgroundColor: Colors.orange.shade900,
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              label: "Cari",
              backgroundColor: Colors.orange.shade900,
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chart_bar_square),
              label: "Data DPT",
              backgroundColor: Colors.orange.shade900,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: "Profile",
              backgroundColor: Colors.orange.shade900,
            ),
          ],
          fixedColor: Colors.green.shade300,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(
              color: Colors.green.shade300, fontWeight: FontWeight.bold),
          selectedIconTheme: IconThemeData(color: Colors.green.shade300),
          currentIndex: seciliMenu,
          unselectedIconTheme: IconThemeData(color: Colors.grey.shade300),
          unselectedLabelStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          onTap: (index) {
            setState(() {
              seciliMenu = index;
            });
          }),
      body: calegPage[seciliMenu],
    );
  }
}
