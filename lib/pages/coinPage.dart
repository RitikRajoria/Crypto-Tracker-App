import 'dart:ui';
import 'package:crypto_app_ui/themes/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CoinPage extends StatefulWidget {

  final String uuid;

  const CoinPage({Key? key, required this.uuid}) : super(key: key);

  

  @override
  _CoinPageState createState() => _CoinPageState();
}



class _CoinPageState extends State<CoinPage> {
  List<TabItemModel> tabItems = [
    TabItemModel(isSelected: false, itemText: '1D'),
    TabItemModel(isSelected: true, itemText: '1W'),
    TabItemModel(isSelected: false, itemText: '1M'),
    TabItemModel(isSelected: false, itemText: '1Y'),
    TabItemModel(isSelected: false, itemText: 'All'),
  ];
  bool favBtn = false;



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
          "<CoinName>",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
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
    

    return Center(
      child: Column(
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
                ),
              )
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "23.456,00",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 28),
              ),
              const SizedBox(width: 12),
              Text(
                "ETH",
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\$12.234,12",
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 5),
              Icon(Icons.arrow_drop_up, color: Colors.greenAccent, size: 30),
              Text(
                "+2,1%",
                style: TextStyle(color: Colors.greenAccent, fontSize: 15),
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
          const SizedBox(height: 5),
          Container(
            height: 220,
            width: (size.width),
            // color: Colors.grey,
            child: LineChartWidget(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("MON",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              Text("TUE",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              Text("WED",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              Text("THU",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              Text("FRI",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              Text("SAT",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              Text("SUN",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
            ],
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
                favBtn = !favBtn;
              
              });

            },
            child: Container(
              height: 50,
              width: (size.width),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Icon(favBtn ? Icons.star : Icons.star_border,size: 30),
                ],
              ),
              
            ),
          ),
        ],
      ),
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
        setState(() {});
      },
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
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        
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
              FlSpot(9, 4),
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

