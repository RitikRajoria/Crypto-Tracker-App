
import 'package:crypto_app_ui/bloc/crypto_event.dart';
import 'package:crypto_app_ui/homepage_navbar.dart';
import 'package:crypto_app_ui/pages/coinPage.dart';
import 'package:crypto_app_ui/pages/home.dart';
import 'package:crypto_app_ui/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/crypto_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // drawer: Drawer(),
      debugShowCheckedModeBanner: false,
      
      home: HomePageNavbar(),
      
      
      routes: {
        // MyRoutes.loginRoute: (context) => LoginPage(),
        MyRoutes.homeRoute: (context) => HomePage(),
        
        
      },
      
    );
  }
}

