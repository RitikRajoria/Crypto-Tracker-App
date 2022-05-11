import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:gradient_borders/gradient_borders.dart';

import 'package:crypto_app_ui/homepage_navbar.dart';
import 'package:crypto_app_ui/models/photoModel.dart';
import 'package:crypto_app_ui/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/profile_photo_handler.dart';

class OnBoardingPage2 extends StatefulWidget {
  const OnBoardingPage2({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage2> createState() => _OnBoardingPage2State();
}

class _OnBoardingPage2State extends State<OnBoardingPage2> {
  bool isLastPage = false;
  Future<File>? imageFile;
  Image? image;
  PhotoDBHelper? dbHelper = PhotoDBHelper();
  List<Photo> images = [];
  bool inProcess = false;
  File? croppedImg;
  FocusNode _focusNode = FocusNode();
  bool avatarError = false;
  bool textError = false;

  File? _selectedFile;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget getSelectedImage() {
    if (_selectedFile != null) {
      return InkWell(
        onTap: () {
          getImage(ImageSource.gallery);
        },
        child: Container(
          height: 130,
          width: 130,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            shape: BoxShape.circle,
            border:
                Border.all(color: Colors.white.withOpacity(0.2), width: 0.6),
            image: DecorationImage(
              image: FileImage(_selectedFile!) as ImageProvider,
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          getImage(ImageSource.gallery);
        },
        child: Container(
          height: 130,
          width: 130,
          decoration: BoxDecoration(
            color: Colors.grey.shade700.withOpacity(0.3),
            shape: BoxShape.circle,
            border:
                Border.all(color: Colors.white.withOpacity(0.2), width: 0.6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.image_outlined,
                  color: Colors.white.withOpacity(0.7), size: 30),
              Text("Select an Image",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7), fontSize: 11)),
            ],
          ),
        ),
      );
    }
  }

  getImage(ImageSource source) async {
    this.setState(() {
      inProcess = true;
    });
    ImagePicker picker = ImagePicker();
    ImageCropper cropper = ImageCropper();
    File? cropped;
    picker.pickImage(source: source).then((image) async {
      if (image != null) {
        cropped = await cropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(
            ratioX: 1,
            ratioY: 1,
          ),
          compressQuality: 70,
          maxWidth: 500,
          maxHeight: 500,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.amberAccent.shade400,
            toolbarTitle: "Cropper",
            statusBarColor: Colors.amber.shade700,
            backgroundColor: Colors.black.withOpacity(0.3),
          ),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        );
        if (cropped != null) {
          this.setState(() {
            _selectedFile = cropped;
            inProcess = false;
            croppedImg = cropped;
          });
        } else {
          this.setState(() {
            inProcess = false;
          });
        }
      } else {
        this.setState(() {
          inProcess = false;
        });
      }
    });
  }

  writeData(File _croppedImg, String username) async {
    if (_croppedImg != null) {
      Uint8List imageBytes = await croppedImg!.readAsBytes();
      String imgString = Utility.base64String(imageBytes);
      Photo photo = Photo(id: 0, name: username, photoName: imgString);
      dbHelper!.save(photo);
      print("entries saved $username");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            !inProcess
                ? Stack(
                    children: [
                      Container(
                        height: size.height,
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            image: ExactAssetImage(
                              "assets/images/onBoardBack.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getSelectedImage(),
                            if (avatarError) SizedBox(height: 5),
                            if (avatarError)
                              Container(
                                child: Text(
                                  "Select an Image",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            SizedBox(
                              height: 35,
                            ),
                            if (textError)
                              Container(
                                width: (size.width) * 0.7,
                                child: Text(
                                  "Enter Username!",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            if (textError)
                              SizedBox(
                                height: 8,
                              ),
                            Container(
                              width: 300,
                              child: TextField(
                                maxLength: 45,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                controller: textController,
                                cursorColor: Colors.amber.shade700,
                                focusNode: _focusNode,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.person,
                                    color: _focusNode.hasFocus
                                        ? Colors.amberAccent
                                        : Colors.grey,
                                  ),
                                  fillColor: Color.fromARGB(100, 32, 32, 32),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(98, 110, 110, 110),
                                        width: 2),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  focusedBorder: GradientOutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      gradient: LinearGradient(colors: [
                                        Colors.amber.shade700,
                                        Colors.amberAccent
                                      ]),
                                      width: 1.4),
                                  hintText: "Enter your Name",
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 60,
                        left: (size.width) * 0.425,
                        child: //sending data to database button
                            InkWell(
                          onTap: () async {
                            if (croppedImg != null) {
                              if (textController.text.isNotEmpty &&
                                  textController.text != " ") {
                                writeData(croppedImg!, textController.text);

                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('showHome', true);

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePageNavbar(
                                            pageNumber: 2,
                                          )),
                                  (Route<dynamic> route) => false,
                                );
                                avatarError = false;
                                textError = false;
                                print("avatarError false textError false");
                              } else {
                                textError = true;
                                avatarError = false;
                                print("Fill textField");
                              }
                            } else {
                              avatarError = true;
                              print("select image");
                            }

                            setState(() {});
                            print(textController.text);
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(Icons.done),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }
}
