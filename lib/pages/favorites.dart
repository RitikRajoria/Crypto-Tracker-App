import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_app_ui/database/fav_handler.dart';
import 'package:crypto_app_ui/pages/home.dart';
import 'package:crypto_app_ui/pages/trendings.dart';
import 'package:crypto_app_ui/pages/coinPage.dart';
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
    // getFavItemList();
    super.initState();
    // setState(() {});
  }

  Future<List<FavsModel>> loadDataFromDB() async {
    listFromdb = dbHelper!.getFavsList();
    print("database loaded");
    return listFromdb;
  }

  int counter = 0;
  int counter1 = 0;
  bool checkComparison = false;

  Future<List<FavItemModel>?> getFavItemList() async {
    CryptoPageResponse? _cryptoData = await CryptoRepository().getCryptoPage();
    List<FavsModel> listFromDB = await dbHelper!.getFavsList();
    favsList = [];

    for (int i = 0; i < _cryptoData.cryptoListing.length; i++) {
      listFromDB.forEach((element) {
        if (element.uuid == _cryptoData.cryptoListing[i].uuid) {
          favsList.add(FavItemModel(
              uuid: _cryptoData.cryptoListing[i].uuid,
              symbol: _cryptoData.cryptoListing[i].symbol,
              name: _cryptoData.cryptoListing[i].name,
              iconUrl: _cryptoData.cryptoListing[i].iconUrl,
              change: _cryptoData.cryptoListing[i].change,
              price: _cryptoData.cryptoListing[i].price));
          // print(favsList[i].uuid);
        }
      });
    }
    return favsList;
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
            FutureBuilder(
              future: getFavItemList(),
              builder: (context, AsyncSnapshot<List<FavItemModel>?> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return SingleChildScrollView(
                      physics: snapshot.data!.length != 0
                          ? BouncingScrollPhysics()
                          : NeverScrollableScrollPhysics(),
                      child: body(size, snapshot));
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Container(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                  color: Colors.white))),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget body(size, snapshot) {
    return Center(
      child: Column(
        children: [
          Column(
            children: [
              viewType
                  ? Container(
                      height: size.height,
                      width: size.width,
                      child: snapshot.data!.length == 0
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
                                          color: Colors.white, fontSize: 18),
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
                                                        Trending()))
                                            .then((value) => onGoback());
                                      },
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(13),
                                        ),
                                        child: Icon(Icons.add_rounded,
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            size: 40),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: snapshot.data.length != 0
                                  ? BouncingScrollPhysics()
                                  : NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(bottom: 157),
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                String price =
                                    double.parse(favsList[index].price)
                                        .toStringAsFixed(2);
                                String url = favsList[index].iconUrl;
                                String logo = url.replaceAll(".svg", ".png");
                                String change = favsList[index].change;
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CoinPage(
                                                    coinId:
                                                        favsList[index].uuid,
                                                    coinName:
                                                        favsList[index].name,
                                                  )),
                                        ).then((value) => onGoback());
                                      },
                                      child: Padding(
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
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    width: 0.2,
                                                    color: Colors.white
                                                        .withOpacity(0.5)),
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                              ),
                                              height: 80,
                                              width: (size.width - 10) * 0.95,
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
                                                          color: Colors.grey
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(24),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(9.5),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: logo,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const CircularProgressIndicator(),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(
                                                                    Icons.error,
                                                                    color: Colors
                                                                        .redAccent),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              width:
                                                                  (size.width -
                                                                          40) *
                                                                      0.4,
                                                              child: Text(
                                                                favsList[index]
                                                                    .name,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      textWhite,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 4),
                                                          Text(
                                                            favsList[index]
                                                                .symbol,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .grey),
                                                          ), //extra alt text for coin
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          "\$${price}",
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            letterSpacing: 0.8,
                                                            color: textWhite,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 3),
                                                      ((change)[0] == "-")
                                                          ? Row(
                                                              children: [
                                                                Text(
                                                                  "- " +
                                                                      change.replaceAll(
                                                                          "-",
                                                                          "") +
                                                                      "%",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                              .redAccent[
                                                                          700]),
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .arrow_downward,
                                                                    size: 15,
                                                                    color: Colors
                                                                            .redAccent[
                                                                        700]),
                                                              ],
                                                            )
                                                          : //change in currency,s value text
                                                          Row(
                                                              children: [
                                                                Text(
                                                                  "+ ${change}" +
                                                                      "%",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                              .greenAccent[
                                                                          700]),
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .arrow_upward,
                                                                    size: 15,
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
                                                              EdgeInsets.all(0),
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
                                                            color: Colors.grey
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
                                                              //List view close button

                                                              dbHelper!.delete(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .uuid);
                                                              print(
                                                                  "1st ${snapshot.data[index].uuid}");
                                                              //
                                                              print(
                                                                  "Deleted item ${snapshot.data[index].name}");
                                                              //
                                                              listFromdb = dbHelper!
                                                                  .getFavsList();

                                                              //

                                                              // snapshot.data
                                                              //     .removeWhere(snapshot
                                                              //             .data[
                                                              //         index]);

                                                              //
                                                              favsList
                                                                  .removeWhere(
                                                                      (element) {
                                                                print(element
                                                                    .uuid);
                                                                return element
                                                                        .uuid ==
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .uuid;
                                                              });

                                                              setState(() {});
                                                            },
                                                            padding: EdgeInsets
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
                                    ),
                                  ],
                                );
                              }),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: snapshot.data!.length == 0
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
                                          color: Colors.white, fontSize: 18),
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
                                                        Trending()))
                                            .then((value) => onGoback());
                                      },
                                      child: Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(13),
                                        ),
                                        child: Icon(Icons.add_rounded,
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            size: 40),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : GridView.builder(
                              physics: snapshot.data.length != 0
                                  ? BouncingScrollPhysics()
                                  : NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              primary: false,
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 230,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext ctx, index) {
                                String price =
                                    double.parse(favsList[index].price)
                                        .toStringAsFixed(3);
                                String url = favsList[index].iconUrl;
                                String logo = url.replaceAll(".svg", ".png");
                                String change = favsList[index].change;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CoinPage(
                                                coinId: favsList[index].uuid,
                                                coinName: favsList[index].name,
                                              )),
                                    ).then((value) => onGoback());
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 30.0, sigmaY: 30.0),
                                      child: Container(
                                        height: (size.width + 30) * 0.50,
                                        width: (size.width - 10) * 0.46,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            width: 1,
                                            color:
                                                Colors.white.withOpacity(0.3),
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
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            width: 0.2,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.close,
                                                          size: 14,
                                                          color: Colors.white70,
                                                        ),
                                                        onPressed: () {
                                                          //grid view close button

                                                          dbHelper!.delete(
                                                              snapshot
                                                                  .data[index]
                                                                  .uuid);
                                                          print(
                                                              "1st ${snapshot.data[index].uuid}");
                                                          //
                                                          print(
                                                              "Deleted item ${snapshot.data[index].name}");
                                                          //
                                                          listFromdb = dbHelper!
                                                              .getFavsList();

                                                          //

                                                          // snapshot.data
                                                          //     .removeWhere(snapshot
                                                          //             .data[
                                                          //         index]);

                                                          //
                                                          favsList.removeWhere(
                                                              (element) {
                                                            print(element.uuid);
                                                            return element
                                                                    .uuid ==
                                                                snapshot
                                                                    .data[index]
                                                                    .uuid;
                                                          });

                                                          setState(() {});
                                                        },
                                                        padding:
                                                            EdgeInsets.all(0),
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
                                                    height: 55,
                                                    width: 55,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl: logo,
                                                        placeholder: (context,
                                                                url) =>
                                                            const CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error,
                                                                color: Colors
                                                                    .redAccent),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        favsList[index].symbol,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: textWhite,
                                                        ),
                                                      ),
                                                      Text(
                                                        favsList[index].name,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[500]),
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
                                                    "\$${price}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: textWhite,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 3),
                                                  ((change)[0] == "-")
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "- " +
                                                                  change
                                                                      .replaceAll(
                                                                          "-",
                                                                          "") +
                                                                  "%",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                          .redAccent[
                                                                      700]),
                                                            ),
                                                            Icon(
                                                                Icons
                                                                    .arrow_downward,
                                                                size: 16,
                                                                color: Colors
                                                                        .redAccent[
                                                                    700]),
                                                          ],
                                                        )
                                                      : //change in currency,s value text
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "+ ${change}" +
                                                                  "%",
                                                              style: TextStyle(
                                                                  fontSize: 14,
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
                                            ),
                                          ],
                                        ),
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

  onGoback() {
    editOn = false;
    setState(() {});
  }
}
