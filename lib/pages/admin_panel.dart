import 'dart:io';

import 'package:Blue_Waves/connection.dart';
import 'package:Blue_Waves/controllers/beach_controller.dart';
import 'package:Blue_Waves/models/Beach.dart';
import 'package:Blue_Waves/pages/locate_beach.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'components/loader.dart';

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _nameController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _latitudeController = TextEditingController();

  final _longitudeController = TextEditingController();

  final _imageOneController = TextEditingController();

  final _imageTwoController = TextEditingController();

  final _imageThreeController = TextEditingController();

  final _imageFourController = TextEditingController();

  var imageOneLink = 'no image selected';
  var imageTwoLink = 'no image selected';
  var imageThreeLink = 'no image selected';
  var imageFourLink = 'no image selected';

  double longitude = 0.0;
  double latitude = 0.0;

  File imageOne;
  File imageTwo;
  File imageThree;
  File imageFour;

  bool isLoading = false;

  Future<List<String>> uploadPhotos() async {
    List<String> images = [];

    // Start uploading
    if (imageOne != null) {
      await storage.ref().child(imageOne.toString()).putFile(imageOne).then(
        (snapshot) async {
          var downloadLink = await snapshot.ref.getDownloadURL();
          images.add(downloadLink);
        },
      );
    }
    if (imageTwo != null) {
      await storage.ref().child(imageTwo.toString()).putFile(imageTwo).then(
        (snapshot) async {
          var downloadLink = await snapshot.ref.getDownloadURL();
          images.add(downloadLink);
        },
      );
    }
    if (imageThree != null) {
      await storage.ref().child(imageThree.toString()).putFile(imageThree).then(
        (snapshot) async {
          var downloadLink = await snapshot.ref.getDownloadURL();
          images.add(downloadLink);
        },
      );
    }
    if (imageFour != null) {
      await storage.ref().child(imageFour.toString()).putFile(imageFour).then(
        (snapshot) async {
          var downloadLink = await snapshot.ref.getDownloadURL();
          images.add(downloadLink);
        },
      );
    }

    return images;
  }

  @override
  void initState() {
    logger.i(Get.arguments.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Loader()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'NAME',
                        ),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'DESCRIPTION',
                        ),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        var location = await Get.to(LocateBeach());
                        setState(() {
                          latitude = location.position.latitude;
                          longitude = location.position.longitude;
                        });
                      },
                      child: Text('Locate beach'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(latitude.toString()),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(longitude.toString()),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          var image = await ImagePicker().getImage(
                            source: ImageSource.gallery,
                          );
                          logger.wtf(image.path);

                          var fileName = image.path;
                          var selectedPhoto = File(fileName);
                          imageOne = selectedPhoto;

                          setState(() {
                            imageOneLink = selectedPhoto.toString();
                            isLoading = false;
                          });
                        },
                        child: Text(imageOneLink)),
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          var image = await ImagePicker().getImage(
                            source: ImageSource.gallery,
                          );
                          logger.wtf(image.path);

                          var fileName = image.path;
                          var selectedPhoto = File(fileName);
                          imageTwo = selectedPhoto;

                          setState(() {
                            imageTwoLink = selectedPhoto.toString();
                            isLoading = false;
                          });
                        },
                        child: Text(imageTwoLink)),
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          var image = await ImagePicker().getImage(
                            source: ImageSource.gallery,
                          );
                          logger.wtf(image.path);

                          var fileName = image.path;
                          var selectedPhoto = File(fileName);
                          imageThree = selectedPhoto;

                          setState(() {
                            imageThreeLink = selectedPhoto.toString();
                            isLoading = false;
                          });
                        },
                        child: Text(imageThreeLink)),
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          var image = await ImagePicker().getImage(
                            source: ImageSource.gallery,
                          );
                          logger.wtf(image.path);

                          var fileName = image.path;
                          var selectedPhoto = File(fileName);
                          imageFour = selectedPhoto;

                          setState(() {
                            imageFourLink = selectedPhoto.toString();
                            isLoading = false;
                          });
                        },
                        child: Text(imageFourLink)),
                    FlatButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        var images = await uploadPhotos();

                        await addBeach(
                          // ignore: missing_required_param
                          Beach(
                            description: _descriptionController.text,
                            images: images,
                            latitude: latitude,
                            longitude: longitude,
                            name: _nameController.text,
                          ),
                        );
                        logger.wtf('NAME ${_nameController.text}');
                        logger
                            .wtf('DESCRIPTION ${_descriptionController.text}');
                        logger.wtf('LATITUDE ${_latitudeController.text}');
                        logger.wtf('LONGITUDE ${_longitudeController.text}');
                        logger.wtf(images);
                        setState(() {
                          isLoading = false;
                          imageOneLink = imageTwoLink = imageThreeLink =
                              imageFourLink = 'image not selected';
                          latitude = longitude = 0.0;
                        });
                      },
                      child: const Text('Add beach'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
