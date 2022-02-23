import 'package:crypto_app_ui/homepage_navbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // drawer: Drawer(),
      
      home: HomePageNavbar(),
      
    );
  }
}

