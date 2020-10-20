import 'dart:async';
import 'dart:typed_data';

import 'package:blue_waves_flutter/controllers/beach_controller.dart';
import 'package:blue_waves_flutter/pages/beach_page.dart';
import 'package:blue_waves_flutter/pages/beaches_stream.dart';
import 'package:blue_waves_flutter/states/loading_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blue_waves_flutter/connection.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'components/animated_background/animated_background.dart';
import 'components/loader.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = true;
  final Completer<GoogleMapController> _controller = Completer();
  CameraPosition greeceCamera;
  Marker beachMarker;
  var markers = [];
  BitmapDescriptor myMarker;

  Future<void> getAllMarkers() async {
    var beaches = await getBeaches();
    myMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)), 'assets/marker.bmp');
    beaches.forEach(
      (beach) {
        markers.add(
          Marker(
            markerId: MarkerId(beach['name']),
            position: LatLng(beach['latitude'], beach['longitude']),
            icon: myMarker,
            infoWindow: InfoWindow(
              title: beach['name'],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BeachPage(
                      beach: beach,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getAllMarkers();
    auth.authStateChanges().listen((User user) {
      if (user == null) {
        logger.w('User is currently signed out');
      } else {
        logger.w('User is signed in');
      }
    });
    beachMarker = Marker(
      markerId: MarkerId('beachMarker'),
      position: const LatLng(39, 23),
    );

    greeceCamera = const CameraPosition(
      target: LatLng(38.2, 24.1),
      zoom: 6,
    );
  }

  @override
  Widget build(BuildContext context) {
    var loader = context.watch<LoadingState>();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const AnimatedBackground(),
            // AllBeaches(),

            loader.isLoading
                ? const Loader()
                : Positioned(
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(60),
                        topLeft: Radius.circular(60),
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 1.8,
                        width: MediaQuery.of(context).size.width,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          markers: {...markers},
                          zoomControlsEnabled: true,
                          zoomGesturesEnabled: true,
                          mapToolbarEnabled: true,
                          myLocationButtonEnabled: false,
                          initialCameraPosition: greeceCamera,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
