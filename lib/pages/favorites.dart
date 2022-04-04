import 'dart:ui';

import 'package:crypto_app_ui/database/fav_handler.dart';
import 'package:crypto_app_ui/pages/home.dart';
import 'package:crypto_app_ui/pages/trendings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/crypto_page_response.dart';
import '../models/crypto_response.dart';
import '../models/favs.dart';
import '../themes/colors.dart';

class Favorites extends StatefulWidget {
  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  FavDBHelper? dbHelper;

  late Future<List<FavsModel>> listFromdb;
  List<FavItemModel> favsList = [];

  @override
  void initState() {
    dbHelper = FavDBHelper();
    getFavLists();
    super.initState();
  }

  // Future getNetworkData() async {
  //   isLoading = true;
  //   _cryptoData = await CryptoRepository().getCryptoPage();
  //   isLoading = false;
  //   setState(() {});
  // }

  // CryptoPageResponse? _cryptoData;

  Future<List<FavsModel>> loadDataFromDB() async {
    listFromdb = dbHelper!.getFavsList();
    return listFromdb;
  }

  bool checkComparison = false;

  Future getFavLists() async {
    CryptoPageResponse? _cryptoData = await CryptoRepository().getCryptoPage();
    List<FavsModel> listFromDB = await dbHelper!.getFavsList();

    for (int i = 0; i <= _cryptoData.cryptoListing.length; i++) {
      favsList.where(
          (element) => element.uuid == _cryptoData.cryptoListing[i].uuid);
    }
  }

  bool isLoading = false;

  bool editOn = false;
  bool viewType = true; //default value is true, true means grid view
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
          "Favorite Coins",
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
          CupertinoButton(
              padding: EdgeInsets.all(0),
              child: Icon(Icons.edit, color: textWhite, size: 20),
              onPressed: () {
                setState(() {
                  editOn = !editOn;
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
            children: [
              viewType
                  ? Container(
                      height: size.height,
                      width: size.width,
                      child: FutureBuilder(
                          future: loadDataFromDB(),
                          builder: (context,
                              AsyncSnapshot<List<FavsModel>> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return snapshot.data!.length == 0
                                  ? Container(
                                      child: Center(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 250,
                                            ),
                                            Text(
                                              'No Favorite Coins Yet!',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Trending()));
                                              },
                                              child: Container(
                                                height: 70,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.4),
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                ),
                                                child: Icon(Icons.add_rounded,
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    size: 40),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: EdgeInsets.only(bottom: 157),
                                      itemCount: snapshot.data?.length,
                                      itemBuilder: (context, index) => Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10, top: 8),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 60.0, sigmaY: 0),
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: Colors.white
                                                            .withOpacity(0.5)),
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                  ),
                                                  height: 80,
                                                  width:
                                                      (size.width - 10) * 0.95,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height: 60,
                                                            width: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .uuid
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      textWhite,
                                                                ),
                                                              ),
                                                              Text(
                                                                "BNB",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .grey),
                                                              ), //extra alt text for coin
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "\$373,98",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: textWhite,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 3),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "+4,33%",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                            .greenAccent[
                                                                        700]),
                                                              ),
                                                              Icon(
                                                                  Icons
                                                                      .arrow_upward,
                                                                  size: 16,
                                                                  color: Colors
                                                                          .greenAccent[
                                                                      700]),
                                                            ],
                                                          ), //change in currency,s value text
                                                        ],
                                                      ),
                                                      if (editOn)
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0),
                                                              height: 30,
                                                              width: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                border: Border.all(
                                                                    width: 0.3,
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.5)),
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.3),
                                                              ),
                                                              child: IconButton(
                                                                icon: Icon(
                                                                    Icons.close,
                                                                    size: 14,
                                                                    color: Colors
                                                                        .white70),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    dbHelper!.delete(snapshot
                                                                        .data![
                                                                            index]
                                                                        .uuid);
                                                                    listFromdb =
                                                                        dbHelper!
                                                                            .getFavsList();
                                                                    snapshot
                                                                        .data!
                                                                        .remove(
                                                                            snapshot.data![index]);
                                                                  });
                                                                },
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          //if here

                                          // if (snapshot.data!.length >= snapshot.data!.length)
                                          //   SizedBox(
                                          //     height: 160,
                                          //   ),
                                        ],
                                      ),
                                    );
                            } else {
                              return Center(
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          }))
                  : Padding(
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Visibility(
                                            visible: editOn,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10,
                                                  bottom: 0,
                                                  top: 10),
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 0.2,
                                                      color: Colors.white),
                                                ),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.close,
                                                    size: 14,
                                                    color: Colors.white70,
                                                  ),
                                                  onPressed: () {},
                                                  padding: EdgeInsets.all(0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: !editOn,
                                            child: Container(
                                                height: 30, width: 30),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 0, right: 5),
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
                                            const SizedBox(height: 3),
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
          const SizedBox(height: 75),
        ],
      ),
    );
  }
}
