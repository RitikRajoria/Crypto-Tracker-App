import 'dart:ui';

import 'package:crypto_app_ui/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/colors.dart';

class Favorites extends StatefulWidget {
  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  bool viewType = true; //default value is true, true means grid view
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(),
        ),),
        backgroundColor: Colors.grey.withOpacity(0.2),
        centerTitle: true,
        title: Text(
          "Favorite Coins",
          style:TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        actions: [
          CupertinoButton(
                                padding: EdgeInsets.all(0),
                                child: viewType == true
                                    ? Icon(Icons.grid_view_rounded,
                                        color: textWhite, size: 20)
                                    : Icon(Icons.view_list_rounded,
                                        color: textWhite, size: 24),
                                onPressed: () {
                                  setState(() {
                                    viewType = !viewType;
                                  });
                                }),
                            CupertinoButton(
                                padding: EdgeInsets.all(0),
                                child: Icon(Icons.edit,
                                    color: textWhite, size: 20),
                                onPressed: () {}),
        ],
      ),
      backgroundColor: bgDark,
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
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 25.0),
                child: Container(),
              ),
            ),
           
            SingleChildScrollView(
              child: body(size),
            ),
          ],
        ),
      ),
    );
  }

  Center body(size) {
    return Center(
        child: Column(
      children: List.generate(
        12,
        (index) => viewType == false
            ? Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(49),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
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
                                      SizedBox(width: 12),
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
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 5, right: 5, bottom: 8),
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
                                      SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            " +4,33%",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.greenAccent[700]),
                                          ),
                                          Icon(Icons.arrow_upward,
                                              size: 16,
                                              color: Colors.greenAccent[700]),
                                        ],
                                      ), //change in currency,s value text
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(49),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
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
                                      SizedBox(width: 12),
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
                                              style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 5, right: 5, bottom: 8),
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
                                      SizedBox(height: 3),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "-3,42%",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.redAccent[700]),
                                          ),
                                          Icon(Icons.arrow_downward,
                                              size: 16,
                                              color: Colors.redAccent[700]),
                                        ],
                                      ), //change in currency,s value text
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      height: 80,
                      width: (size.width - 10) * 0.95,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                        fontSize: 16, color: Colors.grey),
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
                              SizedBox(height: 3),
                              Row(
                                children: [
                                  Text(
                                    "+4,33%",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.greenAccent[700]),
                                  ),
                                  Icon(Icons.arrow_upward,
                                      size: 16, color: Colors.greenAccent[700]),
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
    ));
  }
}
