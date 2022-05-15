import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:blue_waves/api/api_service.dart';
import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/models/beach.dart';
import 'package:blue_waves/pages/beach_page/beach_page.dart';
import 'package:blue_waves/pages/components/animated_background/animated_background.dart';
import 'package:blue_waves/pages/components/animated_background/sun_moon.dart';
import 'package:blue_waves/pages/components/animated_background/title.dart';
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

class GlobeView extends StatefulWidget {
  @override
  _GlobeViewState createState() => _GlobeViewState();
}

class _GlobeViewState extends State<GlobeView> {
  late StreamSubscription<ConnectivityResult> _connectionStatus;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // Create a key
  FirebaseAuth auth = FirebaseAuth.instance;

  bool isAdmin = false;
  bool? hasConn;

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

  Future<void> preparePage() async {
    _beaches = await Api.instance.getAllBeaches();

    _manager.setItems(_beaches);
  }

  // TODO: Prepare page is called twice on first app open. Needs improvement
  /// Method to create a list of Markers and set them to the map.
  Future<void> setMapStyle() async {
    _mapStyle = ThemeState.of(context).isDark
        ? await rootBundle.loadString('map_styles.txt')
        : await rootBundle.loadString('map_styles_light.txt');

    hasConn = await _conn != ConnectivityResult.none;

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
      drawer: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: ThemeState.of(context, listen: true).isDark
              ? kColorBlueDark2
              : kColorBlueLight,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(22.r),
            bottomRight: Radius.circular(22.r),
          ),
        ),
        width: 200.w,
        height: 450.h,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 12.0.h,
            horizontal: 10.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (FirebaseAuth.instance.currentUser != null) ...[
                    Text(
                      S.current.logged_as,
                      style: kStyleDefault.copyWith(
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser?.displayName ?? '',
                      style: kStyleDefault,
                    ),
                  ],
                  if (FirebaseAuth.instance.currentUser != null)
                    Padding(
                      padding: EdgeInsets.only(top: 12.0.h),
                      child: GestureDetector(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          setState(() {});
                        },
                        child: Text(
                          S.current.logout,
                          style: kStyleDefault.copyWith(
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  if (FirebaseAuth.instance.currentUser == null)
                    Text(
                      S.current.notLogged,
                      style: kStyleDefault.copyWith(
                        fontSize: 15.sp,
                      ),
                    ),
                ],
              ),
              if (FirebaseAuth.instance.currentUser == null)
                TextButton(
                  onPressed: () async {
                    await Get.to(() => AuthPage());
                  },
                  child: Text(
                    S.current.login,
                    style: kStyleDefault.copyWith(
                      fontSize: 15.sp,
                    ),
                  ),
                )
              else
                Text(
                  S.current.coming_soon,
                  style: kStyleDefaultBold,
                ),
              if (false)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await Get.to(() => RatedBeaches());
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith(
                          (states) => EdgeInsets.zero,
                        ),
                      ),
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
                      style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith(
                          (states) => EdgeInsets.zero,
                        ),
                      ),
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
                      style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith(
                          (states) => EdgeInsets.zero,
                        ),
                      ),
                      child: Text(
                        S.current.editProfile,
                        style: kStyleDefault.copyWith(
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _mapStyle = ThemeState.of(context).isDark
                            ? await rootBundle
                                .loadString('map_styles_light.txt')
                            : await rootBundle.loadString('map_styles.txt');
                        // ignore: use_build_context_synchronously
                        ThemeState.of(context).toggleTheme();
                        setState(() {});
                      },
                      child: SunMoon(
                        isDark: ThemeState.of(context, listen: true).isDark,
                      ),
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
            ],
          ),
        ),
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
                    : kColorBlueDark,
                size: 45,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          if (LoadingState.of(context, listen: true).isLoading!)
            const AnimatedBackground(),
          if (LoadingState.of(context, listen: true).isLoading!)
            const Center(child: Loader())
          else
            StreamBuilder<ConnectivityResult>(
              stream: _connStream,
              builder: (context, snapshot) {
                final c = snapshot.data;
                if (hasConn != null) {
                  if (c == ConnectivityResult.none || !hasConn!) {
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
                }
                final Completer<GoogleMapController> _controller = Completer();
                return SizedBox(
                  height: 1.sh,
                  width: 1.sw,
                  child: GoogleMap(
                    key: ValueKey(ThemeState.of(context, listen: true).isDark),
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
                );
              },
            ),
          const SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: BlueWavesTitle(
                isBlurred: true,
              ),
            ),
          ),
        ],
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
