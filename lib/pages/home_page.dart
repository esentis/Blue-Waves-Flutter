import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:blue_waves/api/api_service.dart';
import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/models/beach.dart';
import 'package:blue_waves/pages/beach_page/beach_page.dart';
import 'package:blue_waves/pages/components/animated_background/animated_background.dart';
import 'package:blue_waves/pages/components/loader.dart';
import 'package:blue_waves/pages/components/snack_bar.dart';
import 'package:blue_waves/pages/edit_profile_page.dart';
import 'package:blue_waves/pages/favorites_page.dart';
import 'package:blue_waves/pages/rated_beaches.dart';
import 'package:blue_waves/pages/register_login_page/auth_page.dart';
import 'package:blue_waves/states/app_config.dart';
import 'package:blue_waves/states/loading_state.dart';
import 'package:blue_waves/states/theme_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription<ConnectivityResult> _connectionStatus;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // Create a key
  FirebaseAuth auth = FirebaseAuth.instance;

  bool isAdmin = false;
  bool hasConn = false;

  late GoogleMapController mapController;
  CameraPosition greeceCamera = const CameraPosition(
    target: LatLng(38.2, 23.9),
    zoom: 6,
  );
  Marker? beachMarker;
  Set<Marker> markers = {};
  late BitmapDescriptor myMarker;
  String? _mapStyle;
  List<Beach> _beaches = [];
  late ClusterManager<Beach> _manager;
  final _conn = Connectivity().checkConnectivity();
  final Stream<ConnectivityResult> _connStream =
      Connectivity().onConnectivityChanged;

  /// Method to magically create custom marker !!
  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> preparePage() async {
    _beaches = await Api.instance.getAllBeaches();

    log.wtf('Preparing page');
    _manager.setItems(_beaches);
  }

  // TODO: Prepare page is called twice on first app open. Needs improvement
  /// Method to create a list of Markers and set them to the map.
  Future<void> setMapStyle() async {
    final assetBytes = await getBytesFromAsset('assets/images/marker.png', 64);
    myMarker = BitmapDescriptor.fromBytes(assetBytes);
    _mapStyle = await rootBundle.loadString('map_styles.txt');
    hasConn = await _conn != ConnectivityResult.none;
    log.wtf('Connectivity is $hasConn');
    if (!mounted) return;
    if (LoadingState.of(context).isLoading!) {
      LoadingState.of(context).toggleLoading();
    }
    preparePage();
  }

  void _updateMarkers(Set<Marker> markers) {
    log.i('Updated ${markers.length} markers and has connection $hasConn');
    if (mounted) {
      setState(() {
        this.markers = markers;
      });
    }
  }

  ClusterManager<Beach> _initClusterManager() {
    log.i('Initializing cluster manager');
    return ClusterManager<Beach>(
      _beaches,
      _updateMarkers,
      markerBuilder: _markerBuilder,
      stopClusteringZoom: 17.0,
    );
  }

  @override
  void initState() {
    _manager = _initClusterManager();

    super.initState();
    _connectionStatus = _connStream.listen((ConnectivityResult result) {
      log.i('Conn Status Changed :${result.toString()}');
      if (result == ConnectivityResult.none) {
        showSnack(
          title: S.current.error,
          message: S.current.noConnection,
          firstColor: Colors.red[200]!,
          secondColor: Colors.red,
          duration: 3000,
        );
      }
      if (result != ConnectivityResult.none) {
        preparePage();
        hasConn = result != ConnectivityResult.none;
      }
    });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setMapStyle();
    });
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
    _connectionStatus.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Stack(
        children: [
          Positioned(
            top: 90.h,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: kColorBlueDark2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                ),
              ),
              width: 200.w,
              height: 450.h,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.current.menu,
                      style: kStyleDefault,
                    ),
                    if (FirebaseAuth.instance.currentUser == null) ...[
                      TextButton(
                        onPressed: () async {
                          await Get.to(() => AuthPage());
                        },
                        child: Text(
                          S.current.notLogged,
                          style: kStyleDefault.copyWith(
                            fontSize: 15.sp,
                          ),
                        ),
                      )
                    ] else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () async {
                              await Get.to(() => RatedBeaches());
                            },
                            child: Text(
                              S.current.ratedBeaches,
                              style: kStyleDefault.copyWith(
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await Get.to(() => FavoritesPage());
                            },
                            child: Text(
                              S.current.favoritedBeaches,
                              style: kStyleDefault.copyWith(
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await Get.to(() => EditProfilePage());
                            },
                            child: Text(
                              S.current.editProfile,
                              style: kStyleDefault.copyWith(
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    Text(
                      '${S.current.version} ${AppConfig.instance.versionInformation?.version}',
                      style: kStyleDefault.copyWith(
                        fontSize: 14.sp,
                        color: kColorOrangeLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: LoadingState.of(context, listen: true).isLoading!
          ? const SizedBox.shrink()
          : IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: ThemeState.of(context, listen: true).isDark
                    ? kColorWhite
                    : kColorBlue,
                size: 45,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SafeArea(
        child: Stack(
          children: [
            const AnimatedBackground(
              showTitle: true,
            ),
            if (LoadingState.of(context, listen: true).isLoading!)
              const Center(child: Loader())
            else
              StreamBuilder<ConnectivityResult>(
                stream: _connStream,
                builder: (context, snapshot) {
                  final c = snapshot.data;
                  if (c == ConnectivityResult.none || !hasConn) {
                    return Positioned.fill(
                      child: Container(
                        color: kColorBlack.withOpacity(0.8),
                        child: Center(
                          child: Text(
                            S.current.noConnection,
                            style: kStyleDefault,
                          ),
                        ),
                      ),
                    );
                  }
                  final Completer<GoogleMapController> _controller =
                      Completer();
                  return Positioned(
                    bottom: 0,
                    child: FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.r),
                          topLeft: Radius.circular(16.r),
                        ),
                        child: SizedBox(
                          height: 600.h,
                          width: MediaQuery.of(context).size.width,
                          child: GoogleMap(
                            markers: markers,
                            buildingsEnabled: false,
                            myLocationButtonEnabled: false,
                            initialCameraPosition: greeceCamera,
                            zoomControlsEnabled: false,
                            onCameraMove: _manager.onCameraMove,
                            onCameraIdle: _manager.updateMap,
                            onMapCreated: (GoogleMapController controller) {
                              mapController = controller;
                              _manager.setMapId(controller.mapId);
                              mapController.setMapStyle(_mapStyle);
                              _controller.complete(controller);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<Marker> Function(Cluster<Beach>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: cluster.isMultiple
              ? () async {
                  if (cluster.count == 2) {
                    final LatLng latLng_1 = LatLng(
                      cluster.items.first.location.latitude,
                      cluster.items.first.location.longitude,
                    );
                    final LatLng latLng_2 = LatLng(
                      cluster.items.last.location.latitude,
                      cluster.items.last.location.longitude,
                    );

                    // Calculate bounds between two geocoords
                    LatLngBounds bound;
                    if (latLng_1.latitude > latLng_2.latitude &&
                        latLng_1.longitude > latLng_2.longitude) {
                      bound = LatLngBounds(
                        southwest: latLng_2,
                        northeast: latLng_1,
                      );
                    } else if (latLng_1.longitude > latLng_2.longitude) {
                      bound = LatLngBounds(
                        southwest:
                            LatLng(latLng_1.latitude, latLng_2.longitude),
                        northeast:
                            LatLng(latLng_2.latitude, latLng_1.longitude),
                      );
                    } else if (latLng_1.latitude > latLng_2.latitude) {
                      bound = LatLngBounds(
                        southwest:
                            LatLng(latLng_2.latitude, latLng_1.longitude),
                        northeast:
                            LatLng(latLng_1.latitude, latLng_2.longitude),
                      );
                    } else {
                      bound = LatLngBounds(
                        southwest: latLng_1,
                        northeast: latLng_2,
                      );
                    }

                    final CameraUpdate u2 =
                        CameraUpdate.newLatLngBounds(bound, 50);
                    await mapController.animateCamera(u2);
                  } else {
                    await mapController.animateCamera(
                      CameraUpdate.newLatLngZoom(cluster.location, 7),
                    );
                  }
                }
              : () {
                  log.wtf('Tapped on ${cluster.items.first.name}');
                },
          infoWindow: cluster.isMultiple
              ? InfoWindow.noText
              : InfoWindow(
                  title: cluster.items.first.name,
                  onTap: () async {
                    await Get.to(
                      () => BeachPage(
                        beach: cluster.items.first,
                      ),
                    );
                  },
                ),
          icon: await _getMarkerBitmap(
            cluster.isMultiple ? 110 : 50,
            text: cluster.isMultiple ? cluster.count.toString() : null,
          ),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = kColorBlueLight;
    final Paint paint2 = Paint()..color = kColorOrange;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);

    if (text != null) {
      final TextPainter painter =
          TextPainter(textDirection: ui.TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: kStyleDefaultBold.copyWith(
          fontSize: (size / 3).sp,
          color: kColorBlue,
        ),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    // ignore: cast_nullable_to_non_nullable
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}
