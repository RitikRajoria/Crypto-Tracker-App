import 'package:crypto_app_ui/bloc/crypto_event.dart';
import 'package:crypto_app_ui/homepage_navbar.dart';
import 'package:crypto_app_ui/pages/OnBoarding%20Screen/OnBoardingPage1.dart';
import 'package:crypto_app_ui/pages/OnBoarding%20Screen/OnBoardingPage2.dart';
import 'package:crypto_app_ui/pages/coinPage.dart';
import 'package:crypto_app_ui/pages/home.dart';
import 'package:crypto_app_ui/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/crypto_bloc.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  runApp(MyApp(
    showHome: showHome,
  ));
}

class MyApp extends StatelessWidget {
  final bool showHome;

  const MyApp({Key? key, required this.showHome}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // drawer: Drawer(),
      debugShowCheckedModeBanner: false,

      // home: HomePageNavbar(),
      home: showHome ? HomePageNavbar() : OnBoardingPage1(),

      routes: {
        // MyRoutes.loginRoute: (context) => LoginPage(),
        MyRoutes.homeRoute: (context) => HomePage(),
      },
    );
  }
}
