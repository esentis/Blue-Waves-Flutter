import 'dart:io';

import 'package:blue_waves/constants.dart';
import 'package:blue_waves/pages/components/loader.dart';
import 'package:blue_waves/pages/locate_beach.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _nameController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _latitudeController = TextEditingController();

  final _longitudeController = TextEditingController();

  // final _imageOneController = TextEditingController();

  // final _imageTwoController = TextEditingController();

  // final _imageThreeController = TextEditingController();

  // final _imageFourController = TextEditingController();

  String imageOneLink = 'no image selected';
  String imageTwoLink = 'no image selected';
  String imageThreeLink = 'no image selected';
  String imageFourLink = 'no image selected';

  double? longitude = 0.0;
  double? latitude = 0.0;

  File? imageOne;
  File? imageTwo;
  File? imageThree;
  File? imageFour;

  bool isLoading = false;

  @override
  void initState() {
    log.i(Get.arguments.toString());
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
                        final location = await Get.to(LocateBeach());
                        setState(() {
                          latitude = location.position.latitude as double;
                          longitude = location.position.longitude as double;
                        });
                      },
                      child: const Text('Locate beach'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(latitude.toString()),
                          ),
                        ),
                        Flexible(
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
                        final image = await (ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        ) as Future<PickedFile>);
                        log.wtf(image.path);

                        final fileName = image.path;
                        final selectedPhoto = File(fileName);
                        imageOne = selectedPhoto;

                        setState(() {
                          imageOneLink = selectedPhoto.toString();
                          isLoading = false;
                        });
                      },
                      child: Text(imageOneLink),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        final image = await (ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        ) as Future<PickedFile>);
                        log.wtf(image.path);

                        final fileName = image.path;
                        final selectedPhoto = File(fileName);
                        imageTwo = selectedPhoto;

                        setState(() {
                          imageTwoLink = selectedPhoto.toString();
                          isLoading = false;
                        });
                      },
                      child: Text(imageTwoLink),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        final image = await (ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        ) as Future<PickedFile>);
                        log.wtf(image.path);

                        final fileName = image.path;
                        final selectedPhoto = File(fileName);
                        imageThree = selectedPhoto;

                        setState(() {
                          imageThreeLink = selectedPhoto.toString();
                          isLoading = false;
                        });
                      },
                      child: Text(imageThreeLink),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        final image = await (ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        ) as Future<PickedFile>);
                        log.wtf(image.path);

                        final fileName = image.path;
                        final selectedPhoto = File(fileName);
                        imageFour = selectedPhoto;

                        setState(() {
                          imageFourLink = selectedPhoto.toString();
                          isLoading = false;
                        });
                      },
                      child: Text(imageFourLink),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        // await addBeach(
                        //   // ignore: missing_required_param
                        //   Beach(
                        //     description: _descriptionController.text,
                        //     images: images,
                        //     latitude: latitude,
                        //     longitude: longitude,
                        //     name: _nameController.text,
                        //   ),
                        // );
                        log.wtf('NAME ${_nameController.text}');
                        log.wtf('DESCRIPTION ${_descriptionController.text}');
                        log.wtf('LATITUDE ${_latitudeController.text}');
                        log.wtf('LONGITUDE ${_longitudeController.text}');

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
