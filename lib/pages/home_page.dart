import 'dart:async';
import 'dart:typed_data';

import 'package:Blue_Waves/controllers/beach_controller.dart';
import 'package:Blue_Waves/pages/admin_panel.dart';
import 'package:Blue_Waves/pages/favorites_page.dart';
import 'package:Blue_Waves/pages/rated_beaches.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:animate_do/animate_do.dart';

import 'package:Blue_Waves/connection.dart';

import '../connection.dart';
import 'beach_page/beach_page.dart';
import 'components/animated_background/animated_background.dart';
import 'components/loader.dart';

import 'dart:ui' as ui;

import 'edit_profile_page.dart';

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

  BannerAd myBanner = BannerAd(
    adUnitId: DotEnv().env['VAR_ADUNIT_ID'],
    size: AdSize.smartBanner,
    targetingInfo: const MobileAdTargetingInfo(childDirected: true),
    listener: (MobileAdEvent event) {
      print('BannerAd event is $event');
    },
  );

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
    myBanner
      // typically this happens well before the ad is shown
      ..load()
      ..show(
        // Positions the banner ad 60 pixels from the bottom of the screen
        anchorOffset: 0,
        // Positions the banner ad 10 pixels from the center of the screen to the right
        horizontalCenterOffset: 0,
        // Banner Position
        anchorType: AnchorType.bottom,
      );
  }

  @override
  void dispose() {
    mapController.dispose();
    myBanner..dispose();
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
                  ? const Center(child: Loader())
                  : Positioned(
                      bottom: MediaQuery.of(context).size.height / 16,
                      child: FadeInUp(
                        delay: const Duration(milliseconds: 600),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(60),
                            topLeft: Radius.circular(60),
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 1.3,
                            width: MediaQuery.of(context).size.width,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              markers: {...markers},
                              zoomGesturesEnabled: true,
                              myLocationButtonEnabled: false,
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
                    ),
              isLoading
                  ? const SizedBox()
                  : FadeIn(
                      duration: const Duration(milliseconds: 700),
                      child: CircularMenu(
                        alignment: Alignment.topRight,
                        toggleButtonPadding: 15,
                        toggleButtonSize: 25,
                        toggleButtonBoxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            spreadRadius: 2,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 3),
                          )
                        ],
                        curve: Curves.easeIn,
                        reverseCurve: Curves.easeOut,
                        items: [
                          CircularMenuItem(
                              iconSize: 35,
                              padding: 2,
                              margin: 2,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(0, 3),
                                )
                              ],
                              icon: Icons.settings,
                              onTap: () async {
                                await Get.to(EditProfilePage());
                              }),
                          CircularMenuItem(
                              iconSize: 35,
                              padding: 2,
                              margin: 2,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(0, 3),
                                )
                              ],
                              icon: Icons.rate_review,
                              onTap: () async {
                                await Get.to(RatedBeaches());
                              }),
                          CircularMenuItem(
                              iconSize: 35,
                              padding: 2,
                              margin: 2,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(0, 3),
                                )
                              ],
                              icon: Icons.favorite,
                              onTap: () async {
                                await Get.to(FavoritesPage());
                              }),
                          isAdmin
                              ? CircularMenuItem(
                                  iconSize: 35,
                                  padding: 2,
                                  margin: 2,
                                  icon: Icons.admin_panel_settings_sharp,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      spreadRadius: 2,
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                  onTap: () async {
                                    await Get.to(AdminPanel());
                                  })
                              : null,
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
