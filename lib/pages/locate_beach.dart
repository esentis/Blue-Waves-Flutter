import 'dart:async';

import 'package:Blue_Waves/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocateBeach extends StatefulWidget {
  @override
  _LocateBeachState createState() => _LocateBeachState();
}

class _LocateBeachState extends State<LocateBeach> {
  late CameraPosition beachPlace;
  Marker? beachMarker;
  final Completer<GoogleMapController> _controller = Completer();
  @override
  void initState() {
    beachPlace = const CameraPosition(
      target: LatLng(20, 20),
      zoom: 1,
    );
    beachMarker = Marker(
      markerId: MarkerId('beachMarker'),
      position: const LatLng(20, 20),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              child: GoogleMap(
                onCameraMove: (details) {
                  setState(() {
                    log.i(details);
                    beachMarker = Marker(
                      markerId: MarkerId('test'),
                      position: LatLng(
                        details.target.latitude,
                        details.target.longitude,
                      ),
                    );
                  });
                },
                markers: {beachMarker!},
                myLocationButtonEnabled: false,
                initialCameraPosition: beachPlace,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Latitude : ${beachMarker!.position.latitude.toStringAsFixed(2)}\nLongitude : ${beachMarker!.position.longitude.toStringAsFixed(2)}',
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back(result: beachMarker);
                      },
                      child: const Text('Submit location'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
