import 'dart:async';

import 'package:blue_waves_flutter/pages/components/animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BeachPage extends StatefulWidget {
  @override
  _BeachPageState createState() => _BeachPageState();
}

class _BeachPageState extends State<BeachPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(40.0356861, 23.4733686),
    zoom: 14.4746,
  );

  // var newCameraPosition = CameraPosition(
  //   bearing: 192.8334901395799,
  //   target: LatLng(40.0356861, 23.4733686),
  //   tilt: 59.440717697143555,
  //   zoom: 19.151926040649414,
  // );
  // static final CameraPosition _kLake = const CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(40.0356861, 23.4733686),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const AnimatedBackground(),
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  toolbarHeight: MediaQuery.of(context).size.height / 3,
                  stretch: true,
                  elevation: 40,
                  floating: true,
                  forceElevated: true,
                  flexibleSpace: Image.asset(
                    'assets/images/kryopigi.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == 44) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            markers: {
                              Marker(
                                markerId: MarkerId('beachMarker'),
                                position: const LatLng(40.0356861, 23.4733686),
                              ),
                            },
                            zoomControlsEnabled: true,
                            zoomGesturesEnabled: true,
                            mapToolbarEnabled: true,
                            myLocationButtonEnabled: false,
                            initialCameraPosition: _kGooglePlex,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                        );
                      }
                      return Text('$index');
                    },
                    childCount: 45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
