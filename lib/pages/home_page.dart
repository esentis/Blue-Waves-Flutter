import 'dart:async';
import 'dart:typed_data';

import 'package:Blue_Waves/controllers/beach_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:animate_do/animate_do.dart';

import 'package:Blue_Waves/connection.dart';

import '../connection.dart';
import 'beach_page.dart';
import 'components/animated_background/animated_background.dart';
import 'components/loader.dart';

import 'dart:ui' as ui;

import 'landing_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = true;

  GoogleMapController mapController;
  CameraPosition greeceCamera;
  Marker beachMarker;
  var markers = [];
  BitmapDescriptor myMarker;
  String _mapStyle;

  /// Method to magically create custom marker !!
  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    var data = await rootBundle.load(path);
    var codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    var fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  /// Method to create a list of Markers and set them to the map.
  Future<void> getAllMarkers() async {
    _mapStyle = await rootBundle.loadString('map_styles.txt');
    var beaches;
    try {
      beaches = await getBeaches();
    } catch (e) {
      return logger.e(e);
    }

    var assetBytes = await getBytesFromAsset('assets/images/marker.png', 64);
    myMarker = BitmapDescriptor.fromBytes(assetBytes);

    beaches.forEach(
      (beach) {
        markers.add(
          Marker(
            markerId: MarkerId(beach['name']),
            position: LatLng(beach['latitude'], beach['longitude']),
            icon: myMarker,
            infoWindow: InfoWindow(
              title: beach['name'],
              onTap: () async {
                await Get.to(BeachPage(beach: beach));
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
  }

  @override
  Widget build(BuildContext context) {
    var _controller = Completer();
    getAllMarkers();
    return SafeArea(
      child: Scaffold(
        body: FadeIn(
          duration: const Duration(milliseconds: 700),
          child: Stack(
            children: [
              const AnimatedBackground(
                showTitle: true,
              ),
              isLoading
                  ? const SizedBox()
                  : Positioned(
                      left: MediaQuery.of(context).size.width / 3,
                      top: MediaQuery.of(context).size.height / 7,
                      child: FadeInDown(
                        duration: const Duration(milliseconds: 900),
                        child: Column(
                          children: [
                            // FlatButton(
                            //   onPressed: () {
                            //     // addReview('0gaLkHoKgjeBovoMj76l');

                            //     // addBeach(
                            //     //   // ignore: missing_required_param
                            //     //   const Beach(
                            //     //     description:
                            //     //         'Σε απόσταση 4 χιλιομέτρων από τον οικισμό της Ελαφονήσου, στη νότια πλευρά του νησιού βρίσκονται οι δίδυμες παραλίες του Σίμου (μικρή παραλία) και του Σαρακήνικου (μεγάλη παραλία ή Τσερατσίνικο για τους ντόπιους). Η πρόσβαση γίνεται με αυτοκίνητο ενώ κατά τους καλοκαιρινούς μήνες εκτελούνται δρομολόγια με καΐκι από το παλιό λιμάνι της Ελαφονήσου (Σκάλα).',
                            //     //     images: [
                            //     //       'https://i.imgur.com/czFwk0y.jpg',
                            //     //       'https://i.imgur.com/lNKmoXb.jpg',
                            //     //       'https://i.imgur.com/hj5LcIp.jpg',
                            //     //     ],
                            //     //     latitude: 36.46733558,
                            //     //     longitude: 22.98053384,
                            //     //     name: 'Σίμος',
                            //     //   ),
                            //     // );
                            //   },
                            //   child: const Text('TestButton'),
                            // ),
                            Text(
                              'Welcome back',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.adventPro(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await auth.signOut();
                                await Get.to(LandingPage());
                                // Navigator.popAndPushNamed(context, '/');
                              },
                              child: const Icon(
                                Icons.logout,
                                size: 40,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              isLoading
                  ? const Center(child: Loader())
                  : Positioned(
                      bottom: 0,
                      child: FadeInUp(
                        delay: const Duration(milliseconds: 600),
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
                              myLocationEnabled: false,
                              initialCameraPosition: const CameraPosition(
                                target: LatLng(38.2, 24.1),
                                zoom: 6,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                mapController = controller;
                                mapController.setMapStyle(_mapStyle);
                                _controller.complete(controller);
                              },
                            ),
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
