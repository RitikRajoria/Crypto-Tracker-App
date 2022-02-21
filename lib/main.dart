import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Drawer(),
      body: SafeArea(
        child: Stack(
          children: [
            //app bar
            Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.grey, size: 28),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.grey, size: 28),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          //main body
            SingleChildScrollView(
              child: body(size),
            ),

            //bottom bar
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomBar(),
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
          
          
          SizedBox(height: 50),          //Avatar and user name
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text("Hey, Welcome back 👋"),
          SizedBox(height: 8),
          Text(
            "User Name",
            style: TextStyle(fontSize: 20),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text("See All"),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
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
                  width: (size.width - 10) * 0.47,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(49),
                  ),
                ),
                Container(
                  height: (size.width + 30) * 0.50,
                  width: (size.width - 20) * 0.47,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(49),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text("View All"),
              ],
            ),
          ),
          Column(
            children: List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.all(10.0),
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
                                    fontSize: 18, fontWeight: FontWeight.bold),
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
                                fontSize: 18, fontWeight: FontWeight.bold),
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
          SizedBox(height: 90),
        ],
      ),
    );
  }
}
class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: ConvexAppBar(
        style: TabStyle.fixedCircle,

        cornerRadius: 54,
        height: 70,
        elevation: 0,
        top: -20,
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
        onTap: (int index) {},
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        color: Colors.red,
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        color: Colors.red,
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        color: Colors.red,
      ),
    );
  }
}

// Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Container(
//                   height: 70,
//                   width: (size.width - 10) * 0.95,
//                                 child: Row(

//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                             height: 60,
//                             width: 60,
//                             decoration: BoxDecoration(
//                               color: Colors.grey,
//                               borderRadius: BorderRadius.circular(24),
//                             ),
//                         ),

//                         SizedBox(width: 10),

//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Coin Name",
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               "BNB",
//                               style: TextStyle(fontSize: 16, color: Colors.grey),
//                             ), //extra alt text for coin
//                           ],
//                         ),
//                           ],
//                       ),

//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             "\$373,98",
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                             "+4,33%",
//                             style: TextStyle(fontSize: 16, color: Colors.greenAccent[700]),
//                           ),
//                           Icon(Icons.arrow_upward, size: 16,color: Colors.greenAccent[700]),
//                             ],
//                           ), //change in currency,s value text
//                         ],
//                       ),

//                     ],
//                   ),
//                 ),
//               ),
