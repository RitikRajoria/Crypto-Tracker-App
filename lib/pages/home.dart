import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_app_ui/database/fav_handler.dart';
import 'package:crypto_app_ui/database/profile_photo_handler.dart';
import 'package:crypto_app_ui/models/crypto_page_response.dart';
import 'package:crypto_app_ui/models/crypto_response.dart';
import 'package:crypto_app_ui/models/favs.dart';
import 'package:crypto_app_ui/models/photoModel.dart';
import 'package:crypto_app_ui/pages/coinPage.dart';
import 'package:crypto_app_ui/pages/favorites.dart';
import 'package:crypto_app_ui/pages/trendings.dart';
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
  bool isLoading = true;
  bool isfirstTime = true;
  FavDBHelper? favdbHelper;
  late Future<List<FavsModel>> listFromdb;
  List<FavItemModelforHome> favsList = [];
  int favsListLength = 0;
  CryptoPageResponse? cryptoData;

  String? _photoPath;

  @override
  void initState() {
    super.initState();
    isLoading = true;

    photoDBHelper = PhotoDBHelper();
    favdbHelper = FavDBHelper();

    isLoading = false;
    print("false");
  }

//favs element
  Future<List<FavsModel>> loadDataFromDB() async {
    listFromdb = favdbHelper!.getFavsList();
    print("favs database loaded");
    return listFromdb;
  }

  Future<List<FavItemModelforHome>?> getFavItemList() async {
    CryptoPageResponse? _cryptoData = await CryptoRepository().getCryptoPage();
    List<FavsModel> listFromDB = await favdbHelper!.getFavsList();
    favsList = [];

    for (int i = 0; i < _cryptoData.cryptoListing.length; i++) {
      listFromDB.forEach((element) {
        if (element.uuid == _cryptoData.cryptoListing[i].uuid) {
          favsList.add(FavItemModelforHome(
              uuid: _cryptoData.cryptoListing[i].uuid,
              symbol: _cryptoData.cryptoListing[i].symbol,
              name: _cryptoData.cryptoListing[i].name,
              iconUrl: _cryptoData.cryptoListing[i].iconUrl,
              change: _cryptoData.cryptoListing[i].change,
              price: _cryptoData.cryptoListing[i].price,
              sparkdata:
                  _cryptoData.cryptoListing[i].sparkline.cast<String>()));
          // print(favsList[i].uuid);
        }
      });
    }
    favsListLength = favsList.length >= 2
        ? 2
        : favsList.length >= 1
            ? 1
            : 0;
    return favsList;
  }

//for profile photo
  int counter = 0;

  Future<List<Photo>> loadFromPhotoDB() async {
    List<Photo> listofphotos = [];

    listofphotos = await photoDBHelper!.getPhotos();

    _photoPath = await _createFileFromString(listofphotos[0].photoName);
    if (counter < 1) {
      setState(() {});
    }
    counter++;

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

  //Recommendations tab
  int getDataCounter = 0;
  Future<CryptoPageResponse?> getData() async {
    cryptoData = await CryptoRepository().getCryptoPage();

    if (getDataCounter < 1) {
      setState(() {});
    }
    getDataCounter++;
    return cryptoData;
  }

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
          "Crypto Tracker",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        leading: Icon(Icons.person, size: 25),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh_rounded, size: 25)),
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
              child: isLoading
                  ? Center(
                      child: Container(
                          height: 45,
                          width: 45,
                          child:
                              CircularProgressIndicator(color: Colors.white)),
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
      child: Column(
        children: [
          FutureBuilder(
              future: loadFromPhotoDB(),
              builder: (context, AsyncSnapshot<List<Photo>> snapshot) {
                if (snapshot.data != null) {
                  isfirstTime = false;
                  //Avatar and user name

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(
                                width: 1.3,
                                color: Colors.white.withOpacity(0.4)),
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Favorites()))
                        .then((value) => onGoback());
                  },
                  child: Row(
                    children: [
                      Text(
                        "See All",
                        style: TextStyle(color: Colors.amber),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Container(
                height: (size.height) * 0.3,
                width: size.width,
                child: FutureBuilder(
                    future: getFavItemList(),
                    builder: (context,
                        AsyncSnapshot<List<FavItemModelforHome>?> snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        if (favsListLength > 0) {
                          if (favsListLength != 1) {
                            return GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                // scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.only(left: 10),
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1 / 1.14,
                                ),
                                itemCount: favsListLength,
                                itemBuilder: (BuildContext ctx, index) {
                                  List<String?> sparkline =
                                      snapshot.data![index].sparkdata;
                                  String price =
                                      double.parse(snapshot.data![index].price)
                                          .toStringAsFixed(2);
                                  String url = snapshot.data![index].iconUrl;
                                  String logo = url.replaceAll(".svg", ".png");
                                  String change = snapshot.data![index].change;
                                  Color profitlossColor = ((change)[0] == "-")
                                      ? Colors.redAccent.shade700
                                      : Colors.greenAccent.shade700;
                                  List<double?> sparklineData = [];
                                  for (int i = 0; i < sparkline.length; i++) {
                                    if (sparkline[i] == null) {
                                      print("Null data");
                                      sparklineData
                                          .add(double.parse(sparkline[i - 1]!));
                                    } else {
                                      sparklineData
                                          .add(double.parse(sparkline[i]!));
                                    }
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CoinPage(
                                                    coinId: snapshot
                                                        .data![index].uuid,
                                                    coinName: snapshot
                                                        .data![index].name,
                                                  )),
                                        ).then((value) => onGoback());
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(49),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 30.0, sigmaY: 30.0),
                                          child: Container(
                                            height: (size.width + 30) * 0.50,
                                            width: (size.width - 10) * 0.46,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(49),
                                              border: Border.all(
                                                width: 1,
                                                color: profitlossColor,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15,
                                                          top: 28,
                                                          right: 5),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.grey
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(44),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: logo,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            ),
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
                                                      const SizedBox(width: 12),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              snapshot
                                                                  .data![index]
                                                                  .symbol,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                                color:
                                                                    textWhite,
                                                              )),
                                                          Container(
                                                            width: (size.width -
                                                                    70) *
                                                                0.3,
                                                            child: Text(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .name,
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                maxLines: 1,
                                                                softWrap: false,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.6))),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15,
                                                          top: 5,
                                                          right: 5,
                                                          bottom: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    // mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "\$${price}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 0.9,
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
                                                                      change.replaceAll(
                                                                          "-",
                                                                          "") +
                                                                      "%",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          profitlossColor),
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .arrow_downward,
                                                                    size: 16,
                                                                    color:
                                                                        profitlossColor),
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
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          profitlossColor),
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .arrow_upward,
                                                                    size: 16,
                                                                    color:
                                                                        profitlossColor),
                                                              ],
                                                            ), //change in currency,s value text
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Expanded(
                                                  child: LineChartWidget(
                                                      profitlossColor:
                                                          profitlossColor,
                                                      sparkData: sparklineData),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return Row(
                              children: [
                                Container(
                                    height: (size.height) * 0.3,
                                    width: (size.width) * 0.5,
                                    child: GridView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.only(left: 10),
                                        gridDelegate:
                                            SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          // mainAxisSpacing: 10,
                                          childAspectRatio: 1 / 1.14,
                                        ),
                                        itemCount: favsListLength,
                                        itemBuilder: (BuildContext ctx, index) {
                                          List<String?> sparkline =
                                              snapshot.data![index].sparkdata;
                                          String price = double.parse(
                                                  snapshot.data![index].price)
                                              .toStringAsFixed(2);
                                          String url =
                                              snapshot.data![index].iconUrl;
                                          String logo =
                                              url.replaceAll(".svg", ".png");
                                          String change =
                                              snapshot.data![index].change;
                                          Color profitlossColor =
                                              ((change)[0] == "-")
                                                  ? Colors.redAccent.shade700
                                                  : Colors.greenAccent.shade700;
                                          List<double?> sparklineData = [];
                                          for (int i = 0;
                                              i < sparkline.length;
                                              i++) {
                                            if (sparkline[i] == null) {
                                              print("Null data");
                                              sparklineData.add(double.parse(
                                                  sparkline[i - 1]!));
                                            } else {
                                              sparklineData.add(
                                                  double.parse(sparkline[i]!));
                                            }
                                          }
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CoinPage(
                                                            coinId: snapshot
                                                                .data![index]
                                                                .uuid,
                                                            coinName: snapshot
                                                                .data![index]
                                                                .name,
                                                          )),
                                                ).then((value) => onGoback());
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(49),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 30.0,
                                                      sigmaY: 30.0),
                                                  child: Container(
                                                    height: (size.width + 30) *
                                                        0.50,
                                                    width: (size.width - 10) *
                                                        0.46,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              49),
                                                      border: Border.all(
                                                        width: 1,
                                                        color: profitlossColor,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 15,
                                                                  top: 28,
                                                                  right: 5),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                height: 50,
                                                                width: 50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.2),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              44),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(3),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        logo,
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            const CircularProgressIndicator(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(
                                                                            Icons
                                                                                .error,
                                                                            color:
                                                                                Colors.redAccent),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 12),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .symbol,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            18,
                                                                        color:
                                                                            textWhite,
                                                                      )),
                                                                  Text(
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .name,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.6))),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 15,
                                                                  top: 5,
                                                                  right: 5,
                                                                  bottom: 8),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            // mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                "\$${price}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      0.9,
                                                                  color:
                                                                      textWhite,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 3),
                                                              ((change)[0] ==
                                                                      "-")
                                                                  ? Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "- " +
                                                                              change.replaceAll("-", "") +
                                                                              "%",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: profitlossColor),
                                                                        ),
                                                                        Icon(
                                                                            Icons
                                                                                .arrow_downward,
                                                                            size:
                                                                                16,
                                                                            color:
                                                                                profitlossColor),
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
                                                                              color: profitlossColor),
                                                                        ),
                                                                        Icon(
                                                                            Icons
                                                                                .arrow_upward,
                                                                            size:
                                                                                16,
                                                                            color:
                                                                                profitlossColor),
                                                                      ],
                                                                    ), //change in currency,s value text
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Expanded(
                                                          child: LineChartWidget(
                                                              profitlossColor:
                                                                  profitlossColor,
                                                              sparkData:
                                                                  sparklineData),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        })),
                                Container(
                                    height: (size.height) * 0.3,
                                    width: (size.width) * 0.5,
                                    child: GridView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.only(right: 10),
                                        gridDelegate:
                                            SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 1 / 1.14,
                                        ),
                                        itemCount: 1,
                                        itemBuilder: (BuildContext ctx, index) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Trending())).then(
                                                    (value) => onGoback());
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(49),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 30.0,
                                                      sigmaY: 30.0),
                                                  child: Container(
                                                    height: (size.height) * 0.3,
                                                    width: (size.width) * 0.48,
                                                    decoration: BoxDecoration(
                                                      // color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              49),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.5)),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Add More Coins",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 12,
                                                        ),
                                                        Container(
                                                          height: 60,
                                                          width: 60,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 0.5,
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.3)),
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.3),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          17)),
                                                          child: Icon(
                                                              Icons.add_rounded,
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.4),
                                                              size: 40),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        })),
                              ],
                            );
                          }
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Trending()))
                                      .then((value) => onGoback());
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(49),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 30.0, sigmaY: 30.0),
                                    child: Container(
                                      height: (size.height) * 0.3,
                                      width: (size.width) * 0.5,
                                      decoration: BoxDecoration(
                                        // color: Colors.grey,
                                        borderRadius: BorderRadius.circular(49),
                                        border: Border.all(
                                            width: 1,
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Add Coins",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: Colors.white
                                                        .withOpacity(0.3)),
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(17)),
                                            child: Icon(Icons.add_rounded,
                                                color: Colors.white
                                                    .withOpacity(0.4),
                                                size: 40),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }
                    }),
              ),
            ],
          ),
          const SizedBox(height: 8),

          //recommendations tab
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 15),
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
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Trending()))
                        .then((value) => onGoback());
                  },
                  child: Text(
                    "View All",
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
              ],
            ),
          ),

          Column(children: [
            Container(
              height: (size.height) * 0.6,
              width: size.width,
              child: FutureBuilder(
                  future: getData(),
                  builder:
                      (context, AsyncSnapshot<CryptoPageResponse?> snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            String price = double.parse(
                                    cryptoData!.cryptoListing[index].price)
                                .toStringAsFixed(3);
                            String url =
                                cryptoData!.cryptoListing[index].iconUrl;
                            String logo = url.replaceAll(".svg", ".png");
                            String change =
                                cryptoData!.cryptoListing[index].change;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CoinPage(
                                            coinId: cryptoData
                                                ?.cryptoListing[index].uuid,
                                            coinName: cryptoData
                                                ?.cryptoListing[index].name,
                                          )),
                                ).then((value) => onGoback());
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 30.0, sigmaY: 30.0),
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
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: logo,
                                                    placeholder: (context,
                                                            url) =>
                                                        const CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error,
                                                            color: Colors
                                                                .redAccent),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: (size.width) * 0.35,
                                                    child: Text(
                                                      cryptoData!
                                                          .cryptoListing[index]
                                                          .name,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      maxLines: 1,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: textWhite,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    cryptoData!
                                                        .cryptoListing[index]
                                                        .symbol,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey),
                                                  ), //extra alt text for coin
                                                ],
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Container(
                                              width: (size.width) * 0.35,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "\$${price}",
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: textWhite,
                                                        letterSpacing: 0.7),
                                                  ),
                                                  const SizedBox(height: 3),
                                                  ((change)[0] == "-")
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              width:
                                                                  (size.width) *
                                                                      0.3,
                                                              child: Text(
                                                                "- " +
                                                                    change
                                                                        .replaceAll(
                                                                            "-",
                                                                            "") +
                                                                    "%",
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                maxLines: 1,
                                                                softWrap: false,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                            .redAccent[
                                                                        700]),
                                                              ),
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
                                                                  .end,
                                                          children: [
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              width:
                                                                  (size.width) *
                                                                      0.3,
                                                              child: Text(
                                                                "+ ${change}" +
                                                                    "%",
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                maxLines: 1,
                                                                softWrap: false,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                            .greenAccent[
                                                                        700]),
                                                              ),
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Container(
                        height: 100,
                        width: size.width,
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    }
                  }),
            ),
          ]),
          const SizedBox(height: 78),
        ],
      ),
    );
  }

  onGoback() {
    setState(() {});
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

class LineChartWidget extends StatelessWidget {
  final Color profitlossColor;
  final List<double?> sparkData;

  List<Color> get gradientColor => [
        profitlossColor.withOpacity(0.3),
        profitlossColor,
        profitlossColor,
        profitlossColor,
        profitlossColor.withOpacity(0.3),
      ];

  LineChartWidget(
      {Key? key, required this.profitlossColor, required this.sparkData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: false,
        ),
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
