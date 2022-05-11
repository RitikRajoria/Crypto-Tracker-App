import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_app_ui/models/crypto_response.dart';
import 'package:crypto_app_ui/models/crypto_search_response.dart';
import 'package:crypto_app_ui/pages/coinPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/searchModel.dart';
import '../themes/colors.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    super.initState();
  }

  String toTitle(String input) {
    final List<String> splitStr = input.split(' ');
    for (int i = 0; i < splitStr.length; i++) {
      splitStr[i] =
          '${splitStr[i][0].toUpperCase()}${splitStr[i].substring(1)}';
    }
    final output = splitStr.join(' ');
    return output;
  }

  List<SearchModel> searchList = [];
  CryptoSearchPageResponse? _cryptoData;

  Future getData(String searchText) async {
    isLoading = true;
    print("$searchText");
    _cryptoData = await CryptoRepository().getSearchedCoin(searchText);
    isLoading = false;
    setState(() {});
  }

  bool isLoading = false;

  Future<List<SearchModel>> getSearchItemList(String textFieldData) async {
    searchList = [];

    for (int i = 0; i < _cryptoData!.cryptoSearchList.length; i++) {
      if (textFieldData == "") {
        print("Empty");
      } else {
        searchList.add(
          SearchModel(
            uuid: _cryptoData!.cryptoSearchList[i].uuid,
            symbol: _cryptoData!.cryptoSearchList[i].symbol,
            name: _cryptoData!.cryptoSearchList[i].name,
            iconUrl: _cryptoData!.cryptoSearchList[i].iconUrl,
          ),
        );
        setState(() {});
      }
    }

    setState(() {});
    return searchList;
  }

  bool viewType = false; //default value is false, false means grid view
  bool searchIcon = true;

  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("Search");

  FocusNode focusSearch = FocusNode();

  final _searchCoin = TextEditingController();

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
        title: cusSearchBar,
        actions: [
          IconButton(
            splashRadius: 18,
            icon: cusIcon,
            onPressed: () {
              setState(() {
                if (this.cusIcon.icon == Icons.search) {
                  this.cusIcon = Icon(Icons.close);
                  this.cusSearchBar = TextField(
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      getData(value);
                      getSearchItemList(value);
                    },
                    focusNode: focusSearch,
                    controller: _searchCoin,
                    autofocus: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      // focusColor: Colors.white,
                      hintText: "Search Coin",
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  );
                } else {
                  cusIcon = Icon(Icons.search);
                  cusSearchBar = Text("Search");
                  _searchCoin.clear();
                }
              });
            },
          ),
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
              physics: NeverScrollableScrollPhysics(),
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
          Container(
            height: size.height,
            child: FutureBuilder(
                future: getSearchItemList(_searchCoin.text),
                builder: (context, AsyncSnapshot<List<SearchModel>?> snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      _searchCoin.text.isNotEmpty) {
                    return snapshot.data!.length != 0
                        ? ListView.builder(
                            padding: EdgeInsets.only(bottom: 153),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              String url = snapshot.data![index].iconUrl;
                              String logo = url.replaceAll(".svg", ".png");
                              // String change = snapshot.data![index].change;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CoinPage(
                                              coinId:
                                                  snapshot.data![index].uuid,
                                              coinName:
                                                  snapshot.data![index].name,
                                            )),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
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
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl: logo,
                                                        fit: BoxFit.contain,
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
                                                ),
                                                const SizedBox(width: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      snapshot
                                                          .data![index].name,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: textWhite,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 7,
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data![index].symbol,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.grey),
                                                    ), //extra alt text for coin
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                        : Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 32,
                                ),
                                Text(
                                  "No Data Found",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "Try some other words",
                                  style: TextStyle(
                                    letterSpacing: 0.6,
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                  } else {
                    double heightadjust = (size.height) * 0.4;
                    return Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: heightadjust),
                        child: Text("Search for Coins here",
                            style: TextStyle(color: Colors.white)),
                      ),
                    );
                  }
                }),
          ),
          // const SizedBox(height: 75),
        ],
      ),
    );
  }
}
