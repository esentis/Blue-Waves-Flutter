import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  toolbarHeight: MediaQuery.of(context).size.height / 3,
                  stretch: true,
                  elevation: 40,
                  floating: true,
                  forceElevated: true,
                  flexibleSpace: Hero(
                    tag: widget.beach['images'][0],
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        widget.beach['images'][0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ],
                            ),
                            child: Text(
                              widget.beach['description'],
                              style: GoogleFonts.adventPro(
                                fontSize: 22,
                              ),
                            ),
                          ),
                        );
                      } else if (index == 1) {
                        return const SizedBox();
                        // return Container(
                        //   width: 150,
                        //   height: 150,
                        //   child: ListView.builder(
                        //     itemBuilder: (context, index) {
                        //       if (index == 0) {
                        //         return const SizedBox();
                        //       } else {
                        //         return Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: ClipRRect(
                        //             borderRadius: BorderRadius.circular(20),
                        //             child: BWavesImage(
                        //                 url: widget.beach['images'][index]),
                        //           ),
                        //         );
                        //       }
                        //     },
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: widget.beach['images'].length,
                        //   ),
                        // );
                      } else {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
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
                          ),
                        );
                      }
                    },
                    childCount: 3,
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
