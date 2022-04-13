import 'dart:io';
import 'dart:typed_data';

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

  File? _selectedFile;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget getSelectedImage() {
    if (_selectedFile != null) {
      return Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.red, width: 2),
          image: DecorationImage(
            image: FileImage(_selectedFile!) as ImageProvider,
          ),
        ),
      );
    } else {
      return Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: Center(
          child: Text("Select an Image!"),
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              !inProcess
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getSelectedImage(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                getImage(ImageSource.camera);
                              },
                              child: Text("Camera"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                getImage(ImageSource.gallery);
                              },
                              child: Text("Gallery"),
                            ),
                          ],
                        ),
                        Container(
                          width: 250,
                          color: Colors.blue,
                          child: TextField(
                            controller: textController,
                          ),
                        ),

                        //sending data to database button
                        Container(
                          child: ElevatedButton(
                            child: Text("Tap"),
                            onPressed: () async {
                              if (croppedImg != null) {
                                if (textController.text.isNotEmpty &&
                                    textController.text != " ") {
                                  writeData(croppedImg!, textController.text);

                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool('showHome', true);

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomePageNavbar()));
                                } else {
                                  print("Fill textField");
                                }
                              } else {
                                print("select image");
                              }

                              print(textController.text);
                            },
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
      ),
    );
  }
}
