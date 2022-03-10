import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_app_ui/models/crypto_page_response.dart';
import 'package:crypto_app_ui/models/crypto_response.dart';
import 'package:crypto_app_ui/pages/coinPage.dart';
import 'package:crypto_app_ui/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Trending extends StatefulWidget {
  @override
  State<Trending> createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool isLoading = false;

  Future getData() async {
    isLoading = true;
    _cryptoData = await CryptoRepository().getCryptoPage();
    isLoading = false;
    setState(() {});
  }



  CryptoPageResponse? _cryptoData;
  bool viewType = true; //default value is false, false means grid view
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
        child: isLoading
            ? Center(child: CircularProgressIndicator())
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
                      child: ListView.builder(
                        itemCount: _cryptoData?.cryptoListing.length,
                        itemBuilder: (context, index) {
                          String price = double.parse(
                                  _cryptoData?.cryptoListing[index].price)
                              .toStringAsFixed(3);
                          String url =
                              _cryptoData?.cryptoListing[index].iconUrl;
                          String logo = url.replaceAll(".svg", ".png");
                          String change =
                              _cryptoData?.cryptoListing[index].change;

                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 8),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CoinPage(coinId: _cryptoData?.cryptoListing[index].uuid,)),
                    );
                  },
                                                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 60.0, sigmaY: 0),
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                              width: 0.2,
                                              color:
                                                  Colors.white.withOpacity(0.5)),
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
                                                  height: 55,
                                                  width: 55,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(22),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl: logo,
                                                      placeholder: (context,
                                                              url) =>
                                                          const CircularProgressIndicator(),
                                                      errorWidget: (context, url,
                                                              error) =>
                                                          const Icon(Icons.error,color: Colors.redAccent ),
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
                                                      width:
                                                          (size.width - 10) * 0.4,
                                                      child: Text(
                                                        _cryptoData
                                                            ?.cryptoListing[index]
                                                            .name,
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: textWhite,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      _cryptoData
                                                          ?.cryptoListing[index]
                                                          .symbol,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.grey),
                                                    ), //extra alt text for coin
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "\$${price}",
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.8,
                                                    color: textWhite,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                ((change)[0] == "-")
                                                    ? Row(
                                                        children: [
                                                          Text(
                                                            "- " +
                                                                change.replaceAll(
                                                                    "-", "") +
                                                                "%",
                                                            style: TextStyle(
                                                                fontSize: 15,
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
                                                    : Row(
                                                        children: [
                                                          Text(
                                                            "+ ${change}" + "%",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                        .greenAccent[
                                                                    700]),
                                                          ),
                                                          Icon(Icons.arrow_upward,
                                                              size: 15,
                                                              color: Colors
                                                                      .greenAccent[
                                                                  700]),
                                                        ],
                                                      ),
                                                //change in currency,s value text
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (index == 49) SizedBox(height: 158),
                              ],
                            ),
                          );
                        },
                      ),
                    )
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
                          itemCount: _cryptoData?.cryptoListing.length,
                          itemBuilder: (BuildContext ctx, index) {
                            String price = double.parse(
                                    _cryptoData?.cryptoListing[index].price)
                                .toStringAsFixed(3);
                            String url =
                                _cryptoData?.cryptoListing[index].iconUrl;
                            String logo = url.replaceAll(".svg", ".png");
                            String change =
                                _cryptoData?.cryptoListing[index].change;

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
                                      width: 0.8,
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 20, right: 5),
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 25.0, sigmaY: 30.0),
                                                child: Container(
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
                                                      errorWidget: (context, url,
                                                              error) =>
                                                          const Icon(Icons.error,color: Colors.redAccent ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  _cryptoData
                                                      ?.cryptoListing[index]
                                                      .symbol,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: textWhite,
                                                  ),
                                                ),
                                                Text(
                                                  _cryptoData
                                                      ?.cryptoListing[index]
                                                      .name,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white
                                                          .withOpacity(0.6)),
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
                                                fontWeight: FontWeight.bold,
                                                color: textWhite,
                                                letterSpacing: 0.8,
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
                                                                "-", "") +
                                                            "%",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                    .redAccent[
                                                                700]),
                                                      ),
                                                      Icon(Icons.arrow_downward,
                                                          size: 16,
                                                          color: Colors
                                                              .redAccent[700]),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "+ ${change}" + "%",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                    .greenAccent[
                                                                700]),
                                                      ),
                                                      Icon(Icons.arrow_upward,
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
                            );
                          }),
                    ),
            ],
          ),
          const SizedBox(height: 68),
        ],
      ),
    );
  }
}

