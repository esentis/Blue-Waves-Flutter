import 'dart:async';
import 'package:blue_waves_flutter/controllers/beach_controller.dart';
import 'package:blue_waves_flutter/models/Favorite.dart';
import 'package:blue_waves_flutter/models/Review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../connection.dart';

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
  bool hasUserReviewed = false;
  bool isBeachFavorited = false;
  int ratingSum = 0;
  double actualRating = 0;
  List foundReviews = [];
  int totalRatings = 0;

  Future<void> getReviews() async {
    await reviews
        .where('beachId', isEqualTo: widget.beach['id'])
        .get()
        .then((value) => foundReviews = value.docs);

    await favorites
        .where(
          'userId',
          isEqualTo: FirebaseAuth.instance.currentUser.uid,
        )
        .where(
          'beachId',
          isEqualTo: widget.beach['id'],
        )
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        logger.wtf('BEACH WAS FAVORITED AND IT SHOULD SHOW TO REMOVE');
        isBeachFavorited = true;
      }
    });

    if (foundReviews.isNotEmpty) {
      logger.wtf('Ratings found iterating on them');
      foundReviews.forEach((element) {
        ratingSum += element['rating'];
      });
      actualRating = ratingSum / foundReviews.length;
      totalRatings = foundReviews.length;
    }

    logger.i('Found ${foundReviews.length} reviews');
    logger.i('Actual rating is $actualRating');

    hasUserReviewed = foundReviews.any((element) =>
        element['username'] == FirebaseAuth.instance.currentUser.displayName);
    logger.i('Has user reviewed the beach ? $hasUserReviewed');
    setState(() {});
  }

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

    getReviews();
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
                            child: Column(
                              children: [
                                Text(
                                    'Rating : $actualRating out of $totalRatings '),
                                Text(
                                  widget.beach['description'],
                                  style: GoogleFonts.adventPro(
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (index == 1) {
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                addReview(Review(
                                  beachId: widget.beach['id'],
                                  cons: 'A bit hard to get there',
                                  pros: 'Cleanest beach ever',
                                  rating: 10,
                                  userID: FirebaseAuth.instance.currentUser.uid,
                                  username: FirebaseAuth
                                      .instance.currentUser.displayName,
                                ));
                                hasUserReviewed = true;
                                actualRating =
                                    (ratingSum + 10) / (totalRatings + 1);
                                totalRatings += 1;

                                setState(() {});
                              },
                              child: hasUserReviewed
                                  ? const Center(
                                      child: Text(
                                          'YOU HAVE ALREADY REVIEWED THE BEACH'))
                                  : const Icon(
                                      Icons.star,
                                      size: 70,
                                      color: Colors.red,
                                    ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await addFavorite(
                                  Favorite(
                                    beachId: widget.beach['id'],
                                    userId:
                                        FirebaseAuth.instance.currentUser.uid,
                                  ),
                                );
                                setState(() {
                                  isBeachFavorited
                                      ? isBeachFavorited = false
                                      : isBeachFavorited = true;
                                });
                              },
                              child: isBeachFavorited
                                  ? Text('Remove from favorites ?')
                                  : Text('Add to favorites'),
                            ),
                          ],
                        );
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
