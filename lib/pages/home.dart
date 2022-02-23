import 'package:crypto_app_ui/themes/colors.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
        return Scaffold(
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
                      image: ExactAssetImage("assets/images/back.jpg",),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX:10.0 , sigmaY: 10.0),
                    child: Container(),
                  ),
                  
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.menu, color: textWhite, size: 28),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon:
                        Icon(Icons.notifications, color: textWhite, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            //main body
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
          SizedBox(height: 50), //Avatar and user name
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: textWhite,
                border: Border.all(width: 2, color: Colors.red),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text("Hey, Welcome back 👋" , style: TextStyle(color: textWhite),),
          SizedBox(height: 8),
          Text(
            "User Name",
            style: TextStyle(fontSize: 20,color: textWhite),
          ),
          SizedBox(height: 20),
          //favorites tab
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Favorite Coins",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: textWhite),
                ),
                Row(
                  children: [
                    Text("See All", style: TextStyle(color: textWhite),),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: textWhite,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          //favorites cards
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: (size.width + 30) * 0.50,
                  width: (size.width - 10) * 0.46,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(49),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, top: 28, right: 5),
                        child: Row(
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ETH",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                        color: textWhite,),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "\$373,98",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold,
                        color: textWhite,),
                            ),
                            SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "+4,33%",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.greenAccent[700]),
                                ),
                                Icon(Icons.arrow_upward,
                                    size: 16, color: Colors.greenAccent[700]),
                              ],
                            ), //change in currency,s value text
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: (size.width + 30) * 0.50,
                  width: (size.width - 10) * 0.46,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(49),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, top: 28, right: 5),
                        child: Row(
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("BNB",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                        color: textWhite,)),
                                Text("Binance", style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, top: 5, right: 5, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "\$373,98",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold,
                        color: textWhite,),
                            ),
                            SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "+4,33%",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.greenAccent[700]),
                                ),
                                Icon(Icons.arrow_upward,
                                    size: 16, color: Colors.greenAccent[700]),
                              ],
                            ), //change in currency,s value text
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),

          //recommendations tab
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommendations",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                        color: textWhite,),
                ),
                Text("View All", style: TextStyle(
                  
                        color: textWhite,
                ),),
              ],
            ),
          ),
          Column(
            children: List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey.withOpacity(0.3),
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
                                    fontSize: 18, fontWeight: FontWeight.bold,
                        color: textWhite,),
                              ),
                              Text(
                                "BNB",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
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
                                fontSize: 18, fontWeight: FontWeight.bold,
                        color: textWhite,),
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
          SizedBox(height: 78),
        ],
      ),
    );
  }
}

