import 'dart:ui';

import 'package:crypto_app_ui/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Trending extends StatefulWidget {
  @override
  State<Trending> createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  bool viewType = false; //default value is false, false means grid view
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      
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
        title: Text(
          "Trending Coins",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        actions: [
          CupertinoButton(
              padding: EdgeInsets.all(0),
              child: viewType == true
                  ? Icon(Icons.grid_view_rounded, color: textWhite, size: 20)
                  : Icon(Icons.view_list_rounded, color: textWhite, size: 24),
              onPressed: () {
                setState(() {
                  viewType = !viewType;
                });
              }),
          
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
        children: [
          Column(
            children: viewType
                ? List.generate(
                    12,
                    (index) => Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 0),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 0.2,
                                  color: Colors.white.withOpacity(0.5)),
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
                                              fontSize: 16, color: Colors.grey),
                                        ), //extra alt text for coin
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                  )
                : [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                          shrinkWrap: true,
                          primary: false,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 230,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: 12,
                          itemBuilder: (BuildContext ctx, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 30.0, sigmaY: 30.0),
                                child: Container(
                                  height: (size.width + 30) * 0.50,
                                  width: (size.width - 10) * 0.46,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.greenAccent.shade700,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 20, right: 5),
                                        child: Column(
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
                                            SizedBox(height: 3),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "ETH",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: textWhite,
                                                  ),
                                                ),
                                                Text(
                                                  "Ethereum",
                                                  style:
                                                      TextStyle(fontSize: 12),
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
                                            SizedBox(height: 3),
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
                                                    color: Colors
                                                        .greenAccent[700]),
                                              ],
                                            ), //change in currency,s value text
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
          ),
          SizedBox(height: 75),
        ],
      ),
    );
}
}