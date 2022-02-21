import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(),
        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: StyleProvider(
        style: Style(),
        child: ConvexAppBar(
          style: TabStyle.fixedCircle,
          cornerRadius: 20,
          height: 70,
          top: -15,
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
        ),
      ),
    );
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 30;

  @override
  double get activeIconMargin => 5;

  @override
  double get iconSize => 25;

  @override
  TextStyle textStyle(Color color) {
    return TextStyle(fontSize: 10, color: color);
  }

  
}
