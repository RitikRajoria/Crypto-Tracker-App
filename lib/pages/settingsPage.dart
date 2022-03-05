import 'dart:ui';

import 'package:crypto_app_ui/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
            body(size),
          ],
        ),
      ),
    );
  }

  Widget body(Size size) {
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
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      height: (size.height - 228) * 0.3,
                      width: size.width,
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "User Name",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "example@xyzmail.com",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 45,
                      width: (size.width - 60) * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(0.8)),
                          ),
                          onPressed: () {
                            print("tapped and working");
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Edit Profile",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300)),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15)
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
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 8, bottom: 12),
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
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.white,
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
                          left: 15, right: 15, top: 15, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Language",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "English",
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.8)),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 8, top: 0, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Light Mode",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: themeSwitch,
                              onChanged: (bool value) {
                                setState(() {
                                  themeSwitch = value;
                                });
                                print(value);
                              },
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
                          left: 15, right: 15, top: 8, bottom: 14),
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
                          Icon(
                            Icons.logout,
                            size: 22,
                            color: Colors.white,
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
