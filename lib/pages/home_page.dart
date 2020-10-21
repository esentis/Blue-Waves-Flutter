import 'dart:async';
import 'dart:typed_data';

import 'package:blue_waves_flutter/controllers/beach_controller.dart';
import 'package:blue_waves_flutter/pages/beach_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blue_waves_flutter/connection.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart' as lottie;

import 'components/animated_background/animated_background.dart';
import 'components/loader.dart';

import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = true;

  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  CameraPosition greeceCamera;
  Marker beachMarker;
  var markers = [];
  BitmapDescriptor myMarker;
  String _mapStyle;
  User currentUser;
  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    var data = await rootBundle.load(path);
    var codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    var fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

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
                await Navigator.push(
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
    rootBundle.loadString('map_styles.txt').then((string) {
      _mapStyle = string;
    });
    getAllMarkers();
    auth.authStateChanges().listen((User user) {
      if (user == null) {
        logger.w('User is currently signed out');
      } else {
        logger.w('${user.displayName} is signed in ');
        currentUser = user;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FadeIn(
          duration: const Duration(milliseconds: 700),
          child: Stack(
            children: [
              const AnimatedBackground(),
              isLoading
                  ? const SizedBox()
                  : currentUser != null
                      ? Positioned(
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
                                    setState(() {
                                      auth.signOut();
                                      Navigator.popAndPushNamed(context, '/');
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
                                  currentUser.displayName ?? 'No display name',
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
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                      context, '/register');
                                },
                                child: Text(
                                  'Register',
                                  style: GoogleFonts.adventPro(
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await Navigator.pushNamed(context, '/login');
                                },
                                child: Text(
                                  'Sign in',
                                  style: GoogleFonts.adventPro(
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
              isLoading
                  ? const Center(child: Loader())
                  : currentUser != null
                      ? Positioned(
                          bottom: 0,
                          child: FadeInUp(
                            delay: const Duration(milliseconds: 600),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(60),
                                topLeft: Radius.circular(60),
                              ),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 1.8,
                                width: MediaQuery.of(context).size.width,
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  markers: {...markers},
                                  zoomControlsEnabled: true,
                                  zoomGesturesEnabled: true,
                                  mapToolbarEnabled: true,
                                  myLocationButtonEnabled: false,
                                  initialCameraPosition: const CameraPosition(
                                    target: LatLng(38.2, 24.1),
                                    zoom: 6,
                                  ),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    mapController = controller;
                                    mapController.setMapStyle(_mapStyle);

                                    _controller.complete(controller);
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
