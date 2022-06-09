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
import 'package:intl/intl.dart';

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
  var timePeriod = "24h";
  bool isError = false;

  Future getCoinData() async {
    isLoading = true;

    final snackBar = SnackBar(
      content: Text('Error with connecting to server!'),
    );

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
    TabItemModel(isSelected: true, itemText: '1D'),
    TabItemModel(isSelected: false, itemText: '1W'),
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
          overflow: TextOverflow.fade,
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
                  favButton(size),
                ],
              ),
      ),
    );
  }

  Widget favButton(Size size) {
    return Positioned(
      bottom: 25,
      right: 12,
      left: 10,
      child: Center(
        child: Container(
          height: 57,
          width: 57,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: FutureBuilder(
            builder: ((context, snapshot) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (favBtn == false) {
                      dbHelper!
                          .insert(FavsModel(
                              uuid: widget.coinId, name: widget.coinName))
                          .then((value) {
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
                child: Container(
                  child: Center(
                      child: Icon(favBtn ? Icons.star : Icons.star_border,
                          size: 30)),
                ),
              );
            }),
            future: entryCheck(),
          ),
        ),
      ),
    );
  }

  Widget body(size) {
    int difference = dateDifference();
    bool isTabSelected = false;
    String price =
        double.parse(_cryptoCoinData!.data.coin.price!).toStringAsFixed(3);
    String change = _cryptoCoinData!.data.coin.change!;
    String url = _cryptoCoinData!.data.coin.iconUrl!;
    String logo = url.replaceAll(".svg", ".png");
    List<String?> sparkline = _cryptoCoinData!.data.coin.sparkline;

    List<double> sparklineData = [];

    final ErrorSnackBar = SnackBar(
      content: Text('No Data Found for this Coin!'),
    );
    print(sparkline.length);

    if (sparkline[0] != null) {
      var prevNotNullValue;
      for (int i = 0; i < sparkline.length; i++) {
        if (sparkline[i] != null) {
          sparklineData.add(double.parse(sparkline[i]!));
          prevNotNullValue = sparkline[i]!;
        } else {
          print("Null sparklinedata");
          sparklineData.add(double.parse(prevNotNullValue));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar);
      Navigator.pop(context);
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        Stack(
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                border: Border.all(
                  width: 0.6,
                  color: Colors.white.withOpacity(0.6),
                ),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CachedNetworkImage(
                  imageUrl: logo,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.redAccent),
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
              _cryptoCoinData!.data.coin.symbol!,
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
          child: TimeLineTabWidget(difference),
        ),
        const SizedBox(
          height: 60,
        ),
        Expanded(
          child: chart(size, sparklineData),
        ),
      ],
    );
  }

  Widget TimeLineTabWidget(int difference) {
    return Padding(
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
            difference: difference,
          );
        }),
        itemCount: 5,
      ),
    );
  }

  int dateDifference() {
    DateTime listedAt = new DateTime.fromMillisecondsSinceEpoch(
        (_cryptoCoinData!.data.coin.listedAt! * 1000));
    var format = new DateFormat("yMd");
    var dateString = format.format(listedAt);
    DateTime currentDate = DateTime.now();
    var dateString2 = format.format(currentDate);
    final difference = currentDate.difference(listedAt).inDays;
    return difference;
  }

  Widget chart(size, List<double?> sparklineData) {
    return Container(
      // color: Colors.grey,
      child: LineChartWidget(
        sparkData: sparklineData,
      ),
    );
  }

  Widget timelineTab({
    required int index,
    required Function onTap,
    required List<TabItemModel> tabItems,
    required int difference,
  }) {
    Color selectedtextColor = Colors.white;
    Color cardBackColor = Colors.transparent;
    final snackBar = SnackBar(
      content: Text('No Data Found!'),
      duration: Duration(seconds: 1),
    );

    return InkWell(
      onTap: () {
        onTap();

        print("$difference days.");

        if (index == 0) {
          timePeriod = "24h";
        } else if (index == 1) {
          if (difference < 7) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            timePeriod = "7d";
          } else {
            timePeriod = "24h";
          }
        } else if (index == 2) {
          if (difference < 30) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            timePeriod = "30d";
          } else {
            timePeriod = "7d";
          }
        } else if (index == 3) {
          if (difference < 366) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            timePeriod = "30d";
          } else {
            timePeriod = "1y";
          }
        } else if (index == 4) {
          if (difference < 1827) {
            if (difference < 1096) {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              timePeriod = "1y";
            } else {
              timePeriod = "3y";
            }
          } else {
            timePeriod = "5y";
          }
        }
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

  LineChartWidget({Key? key, required this.sparkData}) : super(key: key);

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
              FlSpot(-1, sparkData[0]!),
              for (var i = 0; i < sparkData.length; i++)
                FlSpot(i + 1, sparkData[i]!),
              FlSpot(27, sparkData[24]!),
            ],
            colors: gradientColor,
            barWidth: 1.5,
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
          showTitles: false,
          reservedSize: 1,
          getTextStyles: (context, value) => TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          margin: 0,
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
        rightTitles: SideTitles(
          showTitles: false,
        ),
        topTitles: SideTitles(showTitles: false),
      );
}
