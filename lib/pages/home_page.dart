import 'dart:async';
import 'dart:typed_data';

import 'package:blue_waves_flutter/controllers/beach_controller.dart';
import 'package:blue_waves_flutter/pages/beach_page.dart';
import 'package:blue_waves_flutter/states/loading_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blue_waves_flutter/connection.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';

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
  User currentUser;

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
    var beaches;
    try {
      beaches = await getBeaches();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('map_styles.txt').then((string) {
      _mapStyle = string;
    });
    getAllMarkers();
    // Checking if there is currently user logged
    if (FirebaseAuth.instance.currentUser == null) {
      logger.e('no user logged');
    } else {
      logger.wtf('user is logged');
      currentUser = FirebaseAuth.instance.currentUser;
    }
  }

  @override
  Widget build(BuildContext context) {
    var _controller = Completer();
    var loadingState = context.watch<LoadingState>();
    return SafeArea(
      child: Scaffold(
        body: FadeIn(
          duration: const Duration(milliseconds: 700),
          child: Stack(
            children: [
              const AnimatedBackground(),
              loadingState.isLoading
                  ? const SizedBox()
                  : Positioned(
                      left: MediaQuery.of(context).size.width / 3,
                      top: MediaQuery.of(context).size.height / 7,
                      child: FadeInDown(
                        duration: const Duration(milliseconds: 900),
                        child: Column(
                          children: [
                            FlatButton(
                              onPressed: () {
                                // addReview('0gaLkHoKgjeBovoMj76l');

                                // addBeach(
                                //   Beach(
                                //     description:
                                //         'Στη χερσόνησο της Σιθωνίας, στην ανατολική πλευρά, υπάρχει ένα σύμπλεγμα από παραλίες, γνωστές ως Καβουρότρυπες. Πρόκειται για μικρούς κολπίσκους, κρυμμένους πίσω από ένα υπέροχο πευκοδάσος, με κάτασπρες μικρές αμμουδιές, με κρυστάλλινα τιρκουάζ νερά, με λευκά βράχια και πυκνά πεύκα που φτάνουν μέχρι το κύμα.',
                                //     images: [
                                //       'https://i.imgur.com/qqahW7S.jpg',
                                //       'https://i.imgur.com/B08wCht.jpg',
                                //       'https://i.imgur.com/jRpHwLG.jpg',
                                //       'https://i.imgur.com/A2O0qU7.jpg',
                                //     ],
                                //     latitude: 40.1255055,
                                //     longitude: 23.9700915,
                                //     name: 'Καβουρότρυπες',
                                //   ),
                                // );
                              },
                              child: const Text('TestButton'),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() async {
                                  await auth.signOut();
                                  await Get.to(LandingPage());
                                });
                                // Navigator.popAndPushNamed(context, '/');
                              },
                              child: lottie.Lottie.asset(
                                'assets/images/logout.json',
                                height: 50,
                                width: 50,
                              ),
                            ),
                            Text(
                              'Welcome back',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.adventPro(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              currentUser?.displayName ?? 'No display name',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.adventPro(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff18A6EC),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
              loadingState.isLoading
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
