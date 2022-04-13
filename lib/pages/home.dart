import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto_app_ui/database/profile_photo_handler.dart';
import 'package:crypto_app_ui/models/photoModel.dart';
import 'package:crypto_app_ui/pages/coinPage.dart';
import 'package:crypto_app_ui/themes/colors.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/utility.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PhotoDBHelper? photoDBHelper;
  Future<List<Photo>>? listFromPhoto;
  bool? isLoading;
  Image? profilePhoto;
  String? _photoPath;

  @override
  void initState() {
    isLoading = true;
    photoDBHelper = PhotoDBHelper();
    loadFromPhotoDB();
    isLoading = false;
    setState(() {});

    super.initState();
  }

  Future<List<Photo>> loadFromPhotoDB() async {
    List<Photo> listofphotos = [];
    listofphotos = await photoDBHelper!.getPhotos();
    print("database loaded");
    profilePhoto = Utility.imageFromBase64String(listofphotos[0].photoName);
    _photoPath = await _createFileFromString(listofphotos[0].photoName);

    return listofphotos;
  }

  Future<String> _createFileFromString(String photoName) async {
    final encodedStr = photoName;
    String photoPath;
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".jpg");
    await file.writeAsBytes(bytes);
    photoPath = file.path;
    return photoPath;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: Drawer(
        child: Center(
          child: Text("Drawer"),
        ),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(),
          ),
        ),
        backgroundColor: Colors.grey.withOpacity(0.2),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu)),
        title: Text(
          "Crypto Tracker",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(Icons.person),
          ),
        ],
      ),
      backgroundColor: bgDark,
      body: SafeArea(
        child: Stack(
          children: [
            //app bar

            Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: ExactAssetImage(
                    "assets/images/back.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Container(),
              ),
            ),

            //main body
            SingleChildScrollView(
              child: isLoading!
                  ? Center(
                      child: Container(
                          height: 45,
                          width: 45,
                          child: CircularProgressIndicator()),
                    )
                  : body(size),
            ),
          ],
        ),
      ),
    );
  }

  Widget body(size) {
    return Center(
      child: FutureBuilder(
          future: loadFromPhotoDB(),
          builder: (context, AsyncSnapshot<List<Photo>> snapshot) {
            if (snapshot.data != null) {
              return Column(
                children: [
                  //Avatar and user name
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(width: 2, color: Colors.red),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: Image.file(
                            File(_photoPath!),
                          ).image,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Hey, Welcome back 👋",
                    style: TextStyle(color: textWhite),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.data![0].name,
                    style: TextStyle(
                        fontSize: 20,
                        color: textWhite,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  //favorites tab
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Favorite Coins",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textWhite),
                        ),
                        Row(
                          children: [
                            Text(
                              "See All",
                              style: TextStyle(color: Colors.amber),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  //favorites cards
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => CoinPage()),
                            // );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(49),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                              child: Container(
                                height: (size.width + 30) * 0.50,
                                width: (size.width - 10) * 0.46,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(49),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.greenAccent.shade700,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 28, right: 5),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "ETH",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: textWhite,
                                                ),
                                              ),
                                              Text(
                                                "Ethereum",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white
                                                        .withOpacity(0.6)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          top: 5,
                                          right: 5,
                                          bottom: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "\$373,98",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: textWhite,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                " +4,33%",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors
                                                        .greenAccent[700]),
                                              ),
                                              Icon(Icons.arrow_upward,
                                                  size: 16,
                                                  color:
                                                      Colors.greenAccent[700]),
                                            ],
                                          ), //change in currency,s value text
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: LineChartWidget(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => CoinPage()),
                            // );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(49),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                              child: Container(
                                height: (size.width + 30) * 0.50,
                                width: (size.width - 10) * 0.46,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(49),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.redAccent.shade700,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 28, right: 5),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("BNB",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: textWhite,
                                                  )),
                                              Text("Binance",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white
                                                          .withOpacity(0.6))),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          top: 5,
                                          right: 5,
                                          bottom: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "\$245,98",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: textWhite,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "-3,42%",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        Colors.redAccent[400]),
                                              ),
                                              Icon(Icons.arrow_downward,
                                                  size: 16,
                                                  color: Colors.redAccent[400]),
                                            ],
                                          ), //change in currency,s value text
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: LineChartWidget2(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  //recommendations tab
                  Padding(
                    padding: const EdgeInsets.only(left: 13, right: 23),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recommendations",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: textWhite,
                          ),
                        ),
                        Text(
                          "View All",
                          style: TextStyle(color: Colors.amber),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              height: 80,
                              width: (size.width - 10) * 0.95,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Coin Name",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: textWhite,
                                            ),
                                          ),
                                          Text(
                                            "BNB",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ), //extra alt text for coin
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "\$373,98",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: textWhite,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Text(
                                            "+4,33%",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.greenAccent[700]),
                                          ),
                                          Icon(Icons.arrow_upward,
                                              size: 16,
                                              color: Colors.greenAccent[700]),
                                        ],
                                      ), //change in currency,s value text
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 78),
                ],
              );
            } else {
              return Container(
                height: (size.height - 80) * 0.95,
                child: Center(
                  child: Container(
                    height: 45,
                    width: 45,
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              );
            }
          }),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<Color> gradientColor = [
    Colors.greenAccent.shade700.withOpacity(0.3),
    Colors.greenAccent.shade700,
    Colors.greenAccent.shade700,
    Colors.greenAccent.shade700,
    Colors.greenAccent.shade700.withOpacity(0.3),
  ];
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: false,
        ),
        minX: 0,
        minY: 0,
        maxX: 8,
        maxY: 7,
        titlesData: LineTitles.getTitleData(),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(-2, 3),
              FlSpot(0, 3),
              FlSpot(1, 2),
              FlSpot(2, 4),
              FlSpot(3, 2),
              FlSpot(3.4, 4),
              FlSpot(3.8, 3),
              FlSpot(4.1, 4),
              FlSpot(4.8, 5),
              FlSpot(5.2, 4),
              FlSpot(6.5, 6),
              FlSpot(7, 5),
              FlSpot(8, 5),
              FlSpot(9, 3.8),
              FlSpot(13, 6),
            ],
            colors: gradientColor,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              colors: gradientColor.map((e) => e.withOpacity(0.3)).toList(),
            ),
          ),
        ],
        gridData: FlGridData(
          show: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
      ),
    );
  }
}

class LineTitles {
  static getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 1,
          getTitles: (value) {
            switch (value.toInt()) {
            }
            return '';
          },
          margin: 0,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            switch (value.toInt()) {
            }
            return '';
          },
        ),
        rightTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            switch (value.toInt()) {
            }
            return '';
          },
        ),
        topTitles: SideTitles(showTitles: false),
      );
}

class LineChartWidget2 extends StatelessWidget {
  final List<Color> gradientColor = [
    Colors.redAccent.shade700.withOpacity(0.3),
    Colors.redAccent.shade700,
    Colors.redAccent.shade700,
    Colors.redAccent.shade700,
    Colors.redAccent.shade700.withOpacity(0.3),
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: false,
        ),
        minX: 0,
        minY: 0,
        maxX: 8,
        maxY: 7,
        titlesData: LineTitles.getTitleData(),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(-2, 2),
              FlSpot(0, 2),
              FlSpot(1, 3),
              FlSpot(2, 5),
              FlSpot(3, 2),
              FlSpot(3.4, 4.3),
              FlSpot(3.8, 3.6),
              FlSpot(4.1, 5.2),
              FlSpot(4.8, 4.3),
              FlSpot(5.2, 4),
              FlSpot(6.5, 4.5),
              FlSpot(7, 4),
              FlSpot(8, 3.5),
              FlSpot(9, 3.3),
              FlSpot(13, 3),
            ],
            colors: gradientColor,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              colors: gradientColor.map((e) => e.withOpacity(0.3)).toList(),
            ),
          ),
        ],
        gridData: FlGridData(
          show: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
      ),
    );
  }
}
