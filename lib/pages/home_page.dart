import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:blue_waves/api/api_service.dart';
import 'package:blue_waves/constants.dart';
import 'package:blue_waves/controllers/beach_controller.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/models/beach.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'beach_page/beach_page.dart';
import 'components/animated_background/animated_background.dart';
import 'components/loader.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = true;
  bool isAdmin = false;
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
  final List<ClusterItem<Beach>> _items = [];

  final Completer<GoogleMapController> _controller = Completer();

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

  Future<void> preparePage() async {
    _beaches = await Api.instance.getAllBeaches();

    for (final Beach b in _beaches) {
      _items.add(ClusterItem(LatLng(b.latitude!, b.longitude!), item: b));
    }
    _manager.setItems(_items);
  }

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

  void _updateMarkers(Set<Marker> markers) {
    log.i('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  ClusterManager<Beach> _initClusterManager() {
    log.i('Initializing cluster manager');
    return ClusterManager<Beach>(
      _items,
      _updateMarkers,
      markerBuilder: _markerBuilder,
      stopClusteringZoom: 17.0,
    );
  }

  @override
  void initState() {
    _manager = _initClusterManager();
    preparePage();
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setMapStyle();
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    // myBanner..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: GoogleMap(
                      markers: markers,
                      myLocationButtonEnabled: false,
                      initialCameraPosition: greeceCamera,
                      zoomControlsEnabled: false,
                      onCameraMove: _manager.onCameraMove,
                      onCameraIdle: _manager.updateMap,
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                        _manager.setMapController(controller);
                        mapController.setMapStyle(_mapStyle);
                        _controller.complete(controller);
                      },
                    ),
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

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
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
                        cluster.markers.first.location.latitude,
                        cluster.markers.first.location.longitude);
                    final LatLng latLng_2 = LatLng(
                        cluster.markers.last.location.latitude,
                        cluster.markers.last.location.longitude);

                    final LatLngBounds bound = LatLngBounds(
                      southwest: latLng_1.latitude > latLng_2.latitude
                          ? latLng_2
                          : latLng_1,
                      northeast: latLng_1.latitude > latLng_2.latitude
                          ? latLng_1
                          : latLng_2,
                    );

                    final CameraUpdate u2 =
                        CameraUpdate.newLatLngBounds(bound, 50);
                    await mapController.animateCamera(u2);
                  } else {
                    await mapController.animateCamera(
                        CameraUpdate.newLatLngZoom(cluster.location, 7));
                  }
                }
              : null,
          infoWindow: cluster.isMultiple
              ? const InfoWindow()
              : InfoWindow(
                  title: cluster.items.first?.name,
                  onTap: () async {
                    await Get.to(
                      () => BeachPage(
                        beach: cluster.items.first,
                      ),
                    );
                  },
                ),
          icon: await _getMarkerBitmap(cluster.isMultiple ? 110 : 50,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = const Color(0xff18A6EC);
    final Paint paint2 = Paint()..color = const Color(0xff005295);

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);

    if (text != null) {
      final TextPainter painter =
          TextPainter(textDirection: ui.TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: kStyleDefaultBold.copyWith(
          fontSize: (size / 3).sp,
          color: Colors.orange[100],
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
