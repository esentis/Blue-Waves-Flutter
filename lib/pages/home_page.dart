import 'dart:async';
import 'dart:typed_data';

import 'package:Blue_Waves/controllers/beach_controller.dart';
import 'package:Blue_Waves/pages/admin_panel.dart';
import 'package:Blue_Waves/pages/components/snack_bar.dart';
import 'package:Blue_Waves/pages/favorites_page.dart';
import 'package:Blue_Waves/pages/rated_beaches.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:animate_do/animate_do.dart';

import 'package:Blue_Waves/connection.dart';

import '../connection.dart';
import 'beach_page/beach_page.dart';
import 'components/animated_background/animated_background.dart';
import 'components/loader.dart';

import 'dart:ui' as ui;

import 'edit_profile_page.dart';
import 'landing_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = true;
  bool isAdmin = false;
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
    var assetBytes = await getBytesFromAsset('assets/images/marker.png', 64);
    myMarker = BitmapDescriptor.fromBytes(assetBytes);
    _mapStyle = await rootBundle.loadString('map_styles.txt');

    await FirebaseDatabase.instance
        .reference()
        .child('beaches')
        .once()
        .then((snapshot) {
      Map<dynamic, dynamic> beaches = snapshot.value;

      beaches.forEach(
        (key, value) {
          markers.add(
            Marker(
              markerId: MarkerId(value['name']),
              position: LatLng(value['latitude'], value['longitude']),
              icon: myMarker,
              infoWindow: InfoWindow(
                title: value['name'],
                onTap: () async {
                  await Get.to(BeachPage(beach: value));
                },
              ),
            ),
          );
        },
      );
    }).catchError(
      (onError) => logger.e(onError),
    );
    await isAdminCheck();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> isAdminCheck() async {
    isAdmin = await users
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where('role', isEqualTo: 'admin')
        .get()
        .then((value) {
      // Returns false as the user is not admin
      return value.docs.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllMarkers();
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _controller = Completer();

    return Scaffold(
      body: SafeArea(
        child: FadeIn(
          duration: const Duration(milliseconds: 700),
          child: Stack(
            children: [
              const AnimatedBackground(
                showTitle: true,
              ),
              isLoading
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 5),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 6.1,
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: StreamBuilder(
                            stream: users
                                .where('id',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser.uid)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return GestureDetector(
                                  onTap: () {
                                    showSnack(
                                      title: 'Τι είναι οι πόντοι;',
                                      duration: 2300,
                                      message:
                                          'Κάθε φορά που βαθμολογείς μια παραλία κερδίζεις πόντους !',
                                      firstColor:
                                          Colors.blueAccent.withOpacity(0.8),
                                      secondColor: Colors.blue.withOpacity(0.7),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Πόντοι',
                                            style: GoogleFonts.adventPro(
                                              fontSize: 20,
                                              color: Colors.orange[50],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            snapshot.data.docs.first
                                                .data()['karma']
                                                .toString(),
                                            style: GoogleFonts.adventPro(
                                              fontSize: 25,
                                              color: Colors.orange[50],
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return const CircularProgressIndicator();
                            },
                          ),
                        ),
                      ),
                    ),
              isLoading
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.topCenter,
                      child: FadeInDown(
                        duration: const Duration(milliseconds: 900),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await Get.to(FavoritesPage());
                                },
                                child: const Icon(
                                  Icons.favorite,
                                  size: 40,
                                  color: Colors.red,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await Get.to(RatedBeaches());
                                },
                                child: const Icon(
                                  Icons.rate_review_outlined,
                                  size: 40,
                                  color: Colors.red,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await Get.to(EditProfilePage());
                                },
                                child: Icon(
                                  Icons.settings,
                                  size: 40,
                                  color: Colors.orange[50],
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
                              isAdmin
                                  ? GestureDetector(
                                      onTap: () async {
                                        await Get.to(AdminPanel());
                                        // Navigator.popAndPushNamed(context, '/');
                                      },
                                      child: Icon(
                                        Icons.add_moderator,
                                        size: 40,
                                        color: Colors.green[200],
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
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
