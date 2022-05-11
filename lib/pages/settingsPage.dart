import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:crypto_app_ui/pages/OnBoarding%20Screen/OnBoardingPage1.dart';
import 'package:crypto_app_ui/pages/favorites.dart';
import 'package:crypto_app_ui/pages/search.dart';
import 'package:crypto_app_ui/pages/trendings.dart';
import 'package:crypto_app_ui/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/fav_handler.dart';
import '../database/profile_photo_handler.dart';
import '../models/photoModel.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int counter = 0;
  String? _photoPath;
  PhotoDBHelper? photoDBHelper;
  int? userid;
  FavDBHelper? favdbHelper;

  Future<int> logOut(int id) async {
    final deleteUser = await photoDBHelper?.delete(id);
    final deleteFavsTable = await favdbHelper?.deleteEntries();

    return deleteUser!;
  }

  Future<List<Photo>> loadFromPhotoDB() async {
    List<Photo> listofphotos = [];

    listofphotos = await photoDBHelper!.getPhotos();

    _photoPath = await _createFileFromString(listofphotos[0].photoName);
    if (counter < 1) {
      userid = listofphotos[0].id;
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

  @override
  void initState() {
    super.initState();
    photoDBHelper = PhotoDBHelper();
    favdbHelper = FavDBHelper();
  }

  bool themeSwitch = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
            child: Container(),
          ),
        ),
        backgroundColor: Colors.grey.withOpacity(0.2),
        title: Text("Settings"),
        centerTitle: true,
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
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(),
              ),
            ),

//blur background
//first edit profile container
            SingleChildScrollView(child: body(size, context)),
          ],
        ),
      ),
    );
  }

  Widget body(Size size, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FutureBuilder(
                    future: loadFromPhotoDB(),
                    builder: (context, AsyncSnapshot<List<Photo>> snapshot) {
                      if (snapshot.data != null) {
                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              height: (size.height) * 0.19,
                              width: size.width,
                              child: Column(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.withOpacity(0.4),
                                      border: Border.all(
                                          width: 1.2,
                                          color: Colors.white.withOpacity(0.4)),
                                      image: DecorationImage(
                                        image: Image.file(
                                          File(_photoPath!),
                                        ).image,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    snapshot.data![0].name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
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
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            ),
                          ),
                        );
                      }
                    }),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 14, right: 10, top: 13, bottom: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "CONTENT",
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 12, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Favorites",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Favorites()));
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Trending",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Trending()));
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 8, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Search",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Search()));
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 14, right: 10, top: 13, bottom: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "PREFERENCES",
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Log Out",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              print("log out tapped");
                              logOut(userid!).then((value) async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('showHome', false).then(
                                      (value) =>
                                          Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OnBoardingPage1(),
                                        ),
                                      ),
                                    );
                              });
                            },
                            child: Icon(
                              Icons.logout,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
