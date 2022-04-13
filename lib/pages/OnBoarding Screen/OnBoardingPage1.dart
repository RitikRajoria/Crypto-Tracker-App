import 'package:flutter/material.dart';

class OnBoardingPage1 extends StatefulWidget {
  const OnBoardingPage1({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage1> createState() => _OnBoardingPage1State();
}

class _OnBoardingPage1State extends State<OnBoardingPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 100,
          width: 100,
          child: Text("Page 1"),
        ),
      ),
    );
  }
}
