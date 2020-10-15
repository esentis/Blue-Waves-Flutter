import 'dart:async';

import 'package:blue_waves_flutter/pages/components/animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BeachPage extends StatefulWidget {
  const BeachPage({this.beach});
  final Map<String, dynamic> beach;
  @override
  _BeachPageState createState() => _BeachPageState();
}

class _BeachPageState extends State<BeachPage> {
  final Completer<GoogleMapController> _controller = Completer();
  CameraPosition beachPlace;
  Marker beachMarker;
  @override
  void initState() {
    beachPlace = CameraPosition(
      target: LatLng(widget.beach['latitude'], widget.beach['longitude']),
      zoom: 14.4746,
    );
    beachMarker = Marker(
      markerId: MarkerId('beachMarker'),
      position: LatLng(widget.beach['latitude'], widget.beach['longitude']),
    );
    super.initState();
  }

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
                  flexibleSpace: Image.network(
                    widget.beach['images'][0],
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
                            markers: {beachMarker},
                            zoomControlsEnabled: true,
                            zoomGesturesEnabled: true,
                            mapToolbarEnabled: true,
                            myLocationButtonEnabled: false,
                            initialCameraPosition: beachPlace,
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
