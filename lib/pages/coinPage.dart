import 'dart:developer';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_app_ui/models/coin_detail_view.dart';
import 'package:crypto_app_ui/models/crypto_page_response.dart';
import 'package:crypto_app_ui/models/crypto_response.dart';
import 'package:crypto_app_ui/themes/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../database/fav_handler.dart';
import '../models/favs.dart';

class CoinPage extends StatefulWidget {
  final String coinId;
  final String coinName;

  const CoinPage({Key? key, required this.coinId, required this.coinName})
      : super(key: key);

  @override
  _CoinPageState createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  FavDBHelper? dbHelper;

  late Future<List<FavsModel>> favsList;

  bool favBtn = false;

  @override
  void initState() {
    getCoinData();
    dbHelper = FavDBHelper();
    loadData();

    entryCheck();
    super.initState();
  }

  Future<List<FavsModel>> loadData() async {
    favsList = dbHelper!.getFavsList();
    return favsList;
  }

  Future<bool> entryCheck() async {
    var uuid = widget.coinId;
    var check = dbHelper!.uuidExists(uuid);
    favBtn = await check;
    return check;
  }

  bool isLoading = false;
  var timePeriod = "7d";
  bool isError = false;
  Future getCoinData() async {
    isLoading = true;
    final snackBar = SnackBar(
      content: Text('No Data Found!'),
    );
    print("BEEP BOOP");
    print(widget.coinId);
    try {
      _cryptoCoinData = await CryptoRepository()
          .getCryptoCoinPage(uuid: widget.coinId, time: timePeriod);
    } catch (e) {
      isError = true;
      if (isError) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    isLoading = false;

    setState(() {});
  }

  CoinResponse? _cryptoCoinData;

  List<TabItemModel> tabItems = [
    TabItemModel(isSelected: false, itemText: '1D'),
    TabItemModel(isSelected: true, itemText: '1W'),
    TabItemModel(isSelected: false, itemText: '1M'),
    TabItemModel(isSelected: false, itemText: '1Y'),
    TabItemModel(isSelected: false, itemText: 'All'),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgDark,
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
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          widget.coinName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: Stack(
                  children: [
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
                        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                        child: Container(
                          height: 0,
                          width: 10,
                        ),
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
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
                      filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                      child: Container(),
                    ),
                  ),
                  body(size),
                ],
              ),
      ),
    );
  }

  Widget body(size) {
    bool isTabSelected = false;
    String price =
        double.parse(_cryptoCoinData!.data.coin.price).toStringAsFixed(3);
    String change = _cryptoCoinData!.data.coin.change;
    String url = _cryptoCoinData!.data.coin.iconUrl;
    String logo = url.replaceAll(".svg", ".png");
    List<String?> sparkline = _cryptoCoinData!.data.coin.sparkline;

    var highestPrice = _cryptoCoinData!.data.coin.allTimeHigh.price;

    var allTimeHigh = double.parse(highestPrice);

    List<double?> sparklineData = [];
    print(sparkline.length);

    for (int i = 0; i < sparkline.length; i++) {
      // print(i);

      // print(sparkline[i]);
      if (sparkline[i] == null) {
        print("Null data");
        sparklineData.add(double.parse(sparkline[i - 1]!));
      } else {
        sparklineData.add(double.parse(sparkline[i]!));
      }
      // sparklineData.add(double.parse(sparkline[i]!));
      // print(sparklineData[i]);
    }
    // print("All Time High");
    // print(allTimeHigh);
    // print("SPARKLINE DATA");
    // print(sparklineData);

    return Column(
      children: [
        const SizedBox(height: 20),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 115,
                width: 103,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            ),
            Positioned(
              bottom: 10.5,
              right: 1,
              left: 1,
              child: Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CachedNetworkImage(
                    imageUrl: logo,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.redAccent),
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "\$ ${price}",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 28),
            ),
            const SizedBox(width: 12),
            Text(
              _cryptoCoinData!.data.coin.symbol,
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ((change)[0] == "-")
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_drop_down,
                      size: 33, color: Colors.redAccent[700]),
                  Text(
                    "" + change.replaceAll("-", "") + "%",
                    style:
                        TextStyle(fontSize: 18, color: Colors.redAccent[700]),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_drop_up,
                      size: 33, color: Colors.greenAccent[700]),
                  Text(
                    "${change}" + "%",
                    style:
                        TextStyle(fontSize: 18, color: Colors.greenAccent[700]),
                  ),
                ],
              ),
        const SizedBox(height: 20),
        Container(
          height: 50,
          width: (size.width - 45),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) {
                return timelineTab(
                  onTap: () {
                    tabItems[index].isSelected = true;
                    for (int i = 0; i < tabItems.length; i++) {
                      if (index != i) {
                        tabItems[i].isSelected = false;
                      }
                    }
                  },
                  index: index,
                  tabItems: tabItems,
                );
              }),
              itemCount: 5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 220,
          width: size.width,
          // color: Colors.grey,
          child: LineChartWidget(
            sparkData: sparklineData,
            allTimeHigh: allTimeHigh,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: Colors.white,
            onPrimary: Colors.black,
            shape: CircleBorder(),
          ),
          onPressed: () {
            setState(() {
              if (favBtn == false) {
                dbHelper!.insert(FavsModel(uuid: widget.coinId)).then((value) {
                  print("Added to Favorites ${widget.coinName}");
                  setState(() {
                    favsList = dbHelper!.getFavsList();
                  });
                }).onError((error, stackTrace) {
                  print(error.toString());
                });
              } else if (favBtn == true) {
                dbHelper!.delete(widget.coinId);
                favsList = dbHelper!.getFavsList();
                print("deleted ${widget.coinName}");
              }

              print("button pressed");
              favBtn = !favBtn;
              print(favBtn);
            });
          },
          child: FutureBuilder(
            builder: ((context, snapshot) {
              return Container(
                height: 50,
                width: (size.width),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(favBtn ? Icons.star : Icons.star_border, size: 30),
                  ],
                ),
              );
            }),
            future: entryCheck(),
          ),
        ),
      ],
    );
  }

  Widget timelineTab(
      {required int index,
      required Function onTap,
      required List<TabItemModel> tabItems}) {
    Color selectedtextColor = Colors.white;
    Color cardBackColor = Colors.transparent;

    return InkWell(
      onTap: () {
        onTap();

        if (index == 0) {
          timePeriod = "24h";
        } else if (index == 1) {
          timePeriod = "7d";
        } else if (index == 2) {
          timePeriod = "30d";
        } else if (index == 3) {
          timePeriod = "1y";
        } else if (index == 4) {
          timePeriod = "5y";
        }
        // print(timePeriod);

        getCoinData();
        setState(() {});
      },
      child: GestureDetector(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          width: 45,
          height: 28,
          decoration: BoxDecoration(
            color: tabItems[index].isSelected ? Colors.white : cardBackColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              tabItems[index].itemText,
              style: TextStyle(
                  color: tabItems[index].isSelected
                      ? Colors.black
                      : selectedtextColor),
            ),
          ),
        ),
      ),
    );
  }
}

class TabItemModel {
  final String itemText;
  bool isSelected;

  TabItemModel({required this.itemText, required this.isSelected});
}

class LineChartWidget extends StatelessWidget {
  final List<Color> gradientColor = [
    Colors.grey.withOpacity(0.4),
    Colors.grey,
    Colors.white,
    Colors.grey,
    Colors.grey.withOpacity(0.4),
  ];

  final List<double?> sparkData;
  double allTimeHigh;

  LineChartWidget(
      {Key? key, required this.sparkData, required this.allTimeHigh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("SPARK DATA");
    // print(sparkData);

    return LineChart(
      LineChartData(
        minX: 0,
        minY: 0,
        maxX: 27,
        maxY: _maxYvalue(sparkData),
        titlesData: LineTitles.getTitleData(),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(-10, sparkData[0]!),
              for (var i = 0; i < sparkData.length; i++)
                FlSpot(i + 1, sparkData[i]!),
              FlSpot(35, sparkData[26]!),
            ],
            colors: gradientColor,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              colors: gradientColor.map((e) => e.withOpacity(0.2)).toList(),
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

  double _maxYvalue(List<double?> list) {
    double max = 0;
    for (var i = 0; i < list.length; i++) {
      if (list[i]! > max) {
        max = list[i]!;
      }
    }
    return max;
  }
}

class LineTitles {
  static getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 1,
          getTextStyles: (context, value) => TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
            }
            return '';
          },
          margin: 8,
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
