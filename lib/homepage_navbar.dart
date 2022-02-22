import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:crypto_app_ui/pages/favorites.dart';
import 'package:crypto_app_ui/pages/home.dart';
import 'package:crypto_app_ui/pages/search.dart';
import 'package:crypto_app_ui/pages/settingsPage.dart';
import 'package:crypto_app_ui/pages/trendings.dart';
import 'package:flutter/material.dart';

class HomePageNavbar extends StatefulWidget {
  HomePageNavbar({Key? key}) : super(key: key);

  @override
  State<HomePageNavbar> createState() => _HomePageNavbarState();
}

class _HomePageNavbarState extends State<HomePageNavbar> {
  int pageIndex = 2;

  List pages = [
    Trending(),
    Search(),
    HomePage(),
    Favorites(),
    SettingsPage(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[pageIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: bottombar(),
          ),
        ],
      ),
    );
  }

  // bottom bar

  Widget bottombar() {
    return Container(
      child: ConvexAppBar(
        style: TabStyle.reactCircle,
        height: 70,
        elevation: 0,
        top: -20,
        curveSize: 80,
        items: [
          TabItem(
            icon: Icons.home,
          ),
          TabItem(
            icon: Icons.map,
          ),
          TabItem(
            icon: Icons.add,
          ),
          TabItem(
            icon: Icons.message,
          ),
          TabItem(
            icon: Icons.people,
          ),
        ],
        initialActiveIndex: 2, //optional, default as 0
        onTap: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
    );
  }
}
