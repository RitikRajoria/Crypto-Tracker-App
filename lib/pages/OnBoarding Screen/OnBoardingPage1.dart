import 'dart:ui';

import 'package:crypto_app_ui/pages/OnBoarding%20Screen/OnBoardingPage2.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class OnBoardingPage1 extends StatefulWidget {
  const OnBoardingPage1({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage1> createState() => _OnBoardingPage1State();
}

class _OnBoardingPage1State extends State<OnBoardingPage1> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double WIDTH = size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: ExactAssetImage(
                  "assets/images/onBoardBack.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 15.0),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            top: 113,
            left: 116,
            child: Container(
              child: CustomPaint(
                size: Size(
                    WIDTH,
                    (WIDTH * 1.8933333333333333)
                        .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                painter: RPSCustomPainter(),
              ),
            ),
          ),
          Positioned(
            top: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: (size.height) * 0.45,
                  width: (size.width) * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(160),
                        bottomRight: Radius.circular(160)),
                    image: DecorationImage(
                        image: ExactAssetImage('assets/images/back.jpg'),
                        fit: BoxFit.fitWidth),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: (size.height) * 0.4,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 35, top: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manage crypto",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 37,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                              wordSpacing: 4),
                        ),
                        Text(
                          "assets more easily",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 37,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                              wordSpacing: 3),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        RichText(
                          text: TextSpan(
                            text:
                                "Start managing all your crypto assets easily now and track all your favorite coins in one application",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                                letterSpacing: 0.7,
                                wordSpacing: 1.2,
                                height: 1.4),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          OnBoardingPage2())));
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                  child: Icon(Icons.arrow_forward_ios_rounded)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 255, 191, 0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(size.width * 0.5949333, size.height * 0.4712148);
    path0.quadraticBezierTo(size.width * 0.5603000, size.height * 0.4693662,
        size.width * 0.5351667, size.height * 0.4692782);
    path0.cubicTo(
        size.width * 0.5192417,
        size.height * 0.4698063,
        size.width * 0.4980000,
        size.height * 0.4692958,
        size.width * 0.4720667,
        size.height * 0.4704401);
    path0.cubicTo(
        size.width * 0.4479667,
        size.height * 0.4715317,
        size.width * 0.4348333,
        size.height * 0.4738556,
        size.width * 0.4044667,
        size.height * 0.4790317);
    path0.quadraticBezierTo(size.width * 0.3808000, size.height * 0.4842077,
        size.width * 0.3656667, size.height * 0.4943486);
    path0.quadraticBezierTo(size.width * 0.3519667, size.height * 0.5025880,
        size.width * 0.3530667, size.height * 0.5206162);
    path0.cubicTo(
        size.width * 0.3563667,
        size.height * 0.5338556,
        size.width * 0.3682667,
        size.height * 0.5403169,
        size.width * 0.3953333,
        size.height * 0.5473063);
    path0.cubicTo(
        size.width * 0.4149333,
        size.height * 0.5525880,
        size.width * 0.4510667,
        size.height * 0.5561972,
        size.width * 0.4784667,
        size.height * 0.5561092);
    path0.quadraticBezierTo(size.width * 0.5486000, size.height * 0.5554930,
        size.width * 0.5774000, size.height * 0.5527993);
    path0.quadraticBezierTo(size.width * 0.6078000, size.height * 0.5486972,
        size.width * 0.6315333, size.height * 0.5438380);
    path0.quadraticBezierTo(size.width * 0.6383333, size.height * 0.5418310,
        size.width * 0.6617333, size.height * 0.5358275);
    path0.quadraticBezierTo(size.width * 0.6742333, size.height * 0.5282218,
        size.width * 0.6785333, size.height * 0.5158979);
    path0.cubicTo(
        size.width * 0.6774667,
        size.height * 0.5035211,
        size.width * 0.6694667,
        size.height * 0.4961620,
        size.width * 0.6401333,
        size.height * 0.4865141);
    path0.cubicTo(
        size.width * 0.6177667,
        size.height * 0.4832394,
        size.width * 0.5956333,
        size.height * 0.4811092,
        size.width * 0.5760000,
        size.height * 0.4804577);
    path0.quadraticBezierTo(size.width * 0.5471667, size.height * 0.4805282,
        size.width * 0.5158000, size.height * 0.4857746);

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
