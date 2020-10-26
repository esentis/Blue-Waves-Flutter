import 'package:Blue_Waves/controllers/beach_controller.dart';
import 'package:Blue_Waves/models/Beach.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatelessWidget {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _imageOneController = TextEditingController();
  final _imageTwoController = TextEditingController();
  final _imageThreeController = TextEditingController();
  final _imageFourController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextFormField(
                  controller: _latitudeController,
                  decoration: const InputDecoration(
                    hintText: 'LATITUDE',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextFormField(
                  controller: _longitudeController,
                  decoration: const InputDecoration(
                    hintText: 'LONGITUDE',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextFormField(
                  controller: _imageOneController,
                  decoration: const InputDecoration(
                    hintText: 'IMAGE 1',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextFormField(
                  controller: _imageTwoController,
                  decoration: const InputDecoration(
                    hintText: 'IMAGE 2',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextFormField(
                  controller: _imageThreeController,
                  decoration: const InputDecoration(
                    hintText: 'IMAGE 3',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextFormField(
                  controller: _imageFourController,
                  decoration: const InputDecoration(
                    hintText: 'IMAGE 4',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              FlatButton(
                onPressed: () {
                  addBeach(
                    // ignore: missing_required_param
                    Beach(
                      description: _descriptionController.text,
                      images: [
                        _imageOneController.text,
                        _imageTwoController.text,
                        _imageThreeController.text,
                        _imageFourController.text,
                      ],
                      latitude: double.parse(_latitudeController.text),
                      longitude: double.parse(_longitudeController.text),
                      name: _nameController.text,
                    ),
                  );
                  // logger.wtf('NAME ${_nameController.text}');
                  // logger.wtf('DESCRIPTION ${_descriptionController.text}');
                  // logger.wtf('LATITUDE ${_latitudeController.text}');
                  // logger.wtf('LONGITUDE ${_longitudeController.text}');
                  // logger.wtf('IMAGE ONE ${_imageOneController.text}');
                  // logger.wtf('IMAGE TWO ${_imageTwoController.text}');
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
