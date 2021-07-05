import 'dart:async';
import 'dart:typed_data';

import 'package:Blue_Waves/controllers/beach_controller.dart';
import 'package:Blue_Waves/models/Beach.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:animate_do/animate_do.dart';

import 'beach_page/beach_page.dart';
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
  bool isAdmin = false;
  late GoogleMapController mapController;
  CameraPosition? greeceCamera;
  Marker? beachMarker;
  List markers = [];
  late BitmapDescriptor myMarker;
  String? _mapStyle;

  /// Method to magically create custom marker !!
  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    final fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  // BannerAd myBanner = BannerAd(
  //   adUnitId: env['VAR_ADUNIT_ID'],
  //   // adUnitId: BannerAd.testAdUnitId,
  //   size: AdSize.smartBanner,
  //   targetingInfo: const MobileAdTargetingInfo(childDirected: true),
  //   listener: (MobileAdEvent event) {
  //     print('BannerAd event is $event');
  //   },
  // );

  /// Method to create a list of Markers and set them to the map.
  Future<void> setMapStyle() async {
    final assetBytes = await getBytesFromAsset('assets/images/marker.png', 64);
    myMarker = BitmapDescriptor.fromBytes(assetBytes);
    _mapStyle = await rootBundle.loadString('map_styles.txt');

    // await isAdminCheck();
    setState(() {
      isLoading = false;
    });
  }

  // Future<void> isAdminCheck() async {
  //   isAdmin = await users
  //       .where('id', isEqualTo: FirebaseAuth.instance.currentUser.uid)
  //       .where('role', isEqualTo: 'admin')
  //       .get()
  //       .then((value) {
  //     // Returns false as the user is not admin
  //     return value.docs.isNotEmpty;
  //   });
  // }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setMapStyle();
    });
    // myBanner
    //   // typically this happens well before the ad is shown
    //   ..load()
    //   ..show(
    //     // Positions the banner ad 60 pixels from the bottom of the screen
    //     anchorOffset: 0,
    //     // Positions the banner ad 10 pixels from the center of the screen to the right
    //     horizontalCenterOffset: 0,
    //     // Banner Position
    //     anchorType: AnchorType.bottom,
    //   );
  }

  @override
  void dispose() {
    mapController.dispose();
    // myBanner..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _controller = Completer();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const AnimatedBackground(
              showTitle: true,
            ),
            if (isLoading)
              const Center(child: Loader())
            else
              Positioned(
                bottom: 0,
                child: FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .8,
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder<List<Beach>>(
                        future: getAllBeaches(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          // ignore: omit_local_variable_types
                          final List<Beach> beaches = snapshot.data!;
                          beaches.forEach((beach) {
                            markers.add(
                              Marker(
                                markerId: MarkerId(beach.name!),
                                position:
                                    LatLng(beach.latitude!, beach.longitude!),
                                icon: myMarker,
                                infoWindow: InfoWindow(
                                  title: beach.name,
                                  onTap: () async {
                                    final beachDetails =
                                        await getBeach(beach.id!);
                                    await Get.to(
                                      () => BeachPage(
                                        beach: beachDetails,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          });

                          return GoogleMap(
                            markers: {...markers as List<Marker>},
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
                          );
                        }),
                  ),
                ),
              ),
            //TODO: Add new menu
            if (isLoading) const SizedBox() else const SizedBox()
          ],
        ),
      ),
    );
  }
}
