import 'dart:async';

import 'package:blue_waves/api/api_service.dart';
import 'package:blue_waves/constants.dart';
import 'package:blue_waves/controllers/beach_controller.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/models/beach.dart';
import 'package:blue_waves/models/favorite.dart';
import 'package:blue_waves/models/rating.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../components/animated_background/animated_background.dart';
import '../components/loader.dart';
import 'beach_image_wrapper.dart';
import 'favorite_icon.dart';

class BeachPage extends StatefulWidget {
  const BeachPage({this.beach});
  final Beach? beach;
  @override
  _BeachPageState createState() => _BeachPageState();
}

class _BeachPageState extends State<BeachPage> {
  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition beachPlace;
  Marker? beachMarker;
  bool hasUserRated = false;
  bool isBeachFavorited = false;
  double ratingSum = 0;
  double actualRating = 0;
  // List foundRatings = [];
  int totalRatings = 0;
  double? chosenRating;
  int currentIndex = 1;
  bool verticalGallery = false;
  bool isLoading = false;

  final PageController _pageController = PageController();

  Future<void> open(BuildContext context, int index) async {
    // await Get.to(
    //   GalleryPhotoViewWrapper(
    //     images: widget.beach!.images,
    //     backgroundDecoration: const BoxDecoration(
    //       color: Color(0xff005295),
    //     ),
    //     initialIndex: index,
    //     scrollDirection: verticalGallery ? Axis.vertical : Axis.horizontal,
    //   ),
    // );
  }

  // Future<void> addFavorite(Favorite favorite) async {
  //   // Checking if user has already favorited the beach
  //   final fav = await favorites
  //       .child(favorite.beachId! + favorite.userId!)
  //       .once()
  //       .then((snapshot) => snapshot.value);

  //   if (fav != null) {
  //     await favorites.child(favorite.beachId! + favorite.userId!).remove();
  //     return log.e('Beach removed from favorites.');
  //   }

  //   // If we are ok to procceed we add the review.
  //   await favorites.child(favorite.beachId! + favorite.userId!).set({
  //     'beachId': favorite.beachId,
  //     'userId': favorite.userId,
  //     'beachName': favorite.beachName,
  //     'date': DateFormat('dd-MM-yyy').format(DateTime.now()),
  //   }).then((value) {
  //     log.i('Beach added to favorites!');
  //     // ignore: invalid_return_type_for_catch_error
  //   }).catchError((onError) => log.e(onError));
  // }

  // Future<Rating?> getRatings() async {
  //   // ignore: omit_local_variable_types
  //   final Rating? rate = await ratings
  //       .child(widget.beach!.id! + FirebaseAuth.instance.currentUser!.uid)
  //       .once()
  //       .then(
  //     (value) {
  //       if (value.value != null) {
  //         return Rating.fromJson(value.value as Map<String, dynamic>);
  //       }
  //       return null;
  //     },
  //   );

  //   await favorites
  //       .child(widget.beach!.id! + FirebaseAuth.instance.currentUser!.uid)
  //       .once()
  //       .then((value) {
  //     if (value.value != null) {
  //       log.wtf('BEACH WAS FAVORITED AND IT SHOULD SHOW TO REMOVE');

  //       isBeachFavorited = true;
  //       return;
  //     }
  //     return;
  //   });

  //   actualRating = widget.beach!.averageRating!;
  //   totalRatings = widget.beach!.ratingCount!;

  //   hasUserRated = rate != null;

  //   log.i('Has user reviewed the beach ? $hasUserRated');
  //   isLoading = false;
  //   chosenRating = rate == null ? 0 : rate.rating;
  //   setState(() {});
  // }

  @override
  void initState() {
    beachPlace = CameraPosition(
      target: LatLng(widget.beach!.latitude!, widget.beach!.longitude!),
      zoom: 14.4746,
    );
    beachMarker = Marker(
      markerId: const MarkerId('beachMarker'),
      position: LatLng(widget.beach!.latitude!, widget.beach!.longitude!),
    );

    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //    getRatings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const AnimatedBackground(
              showTitle: false,
            ),
            if (isLoading)
              const Loader()
            else
              FadeIn(
                duration: const Duration(milliseconds: 700),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    elevation: 25,
                    leading: GestureDetector(
                      onTap: Get.back,
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                    shadowColor: Colors.black,
                    toolbarHeight: MediaQuery.of(context).size.height / 10,
                    backgroundColor: Colors.orange[50]!.withOpacity(0.8),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.beach!.name!,
                              style: GoogleFonts.adventPro(
                                fontSize: 25,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Flexible(
                              child: FutureBuilder<bool>(
                                future: Api.instance.checkFavorite(
                                  userId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  beachId: widget.beach!.id!,
                                ),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    log.wtf(snapshot.data);
                                    return const Loader();
                                  }
                                  isBeachFavorited = snapshot.data!;
                                  return FavoriteIcon(
                                    isBeachFavorited: isBeachFavorited,
                                    onTap: () async {
                                      await Api.instance.toggleFavorite(
                                        userId: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        beachId: widget.beach!.id!,
                                      );

                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Container(
                                color: Colors.transparent,
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height / 4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  // child: PhotoViewGallery.builder(
                                  //   scrollPhysics:
                                  //       const BouncingScrollPhysics(),
                                  //   builder: (BuildContext context, int index) {
                                  //     return PhotoViewGalleryPageOptions(
                                  //       imageProvider: NetworkImage(
                                  //         widget.beach!.images![index],
                                  //       ),
                                  //       minScale:
                                  //           PhotoViewComputedScale.contained,
                                  //       initialScale:
                                  //           PhotoViewComputedScale.covered,
                                  //       tightMode: true,
                                  //       onTapDown: (context, details,
                                  //           controllerValue) {
                                  //         open(context, index);
                                  //       },
                                  //       heroAttributes: PhotoViewHeroAttributes(
                                  //           tag: widget.beach!.images![index]),
                                  //     );
                                  //   },
                                  //   itemCount: widget.beach!.images!.length,
                                  //   loadingBuilder: (context, event) => Center(
                                  //     child: SizedBox(
                                  //       width: 20.0,
                                  //       height: 20.0,
                                  //       child: CircularProgressIndicator(
                                  //         value: event == null
                                  //             ? 0
                                  //             : event.cumulativeBytesLoaded /
                                  //                 event.expectedTotalBytes!,
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   pageController: _pageController,
                                  //   onPageChanged: (index) {
                                  //     setState(
                                  //       () {
                                  //         currentIndex = index + 1;
                                  //       },
                                  //     );
                                  //   },
                                  // ),
                                ),
                              ),
                              // Align(
                              //   alignment: Alignment.bottomRight,
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Text(
                              //       '$currentIndex/${widget.beach!.images!.length}',
                              //       style: kStyleDefaultBold,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '${S.current.pageBeachRating} ${actualRating.toStringAsFixed(1)} / 5',
                              style: GoogleFonts.adventPro(
                                fontSize: 25,
                                color: Colors.orange[50],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' ($totalRatings ${S.current.pageBeachRatings})',
                              style: GoogleFonts.adventPro(
                                fontSize: 17,
                                color: Colors.orange[50],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: hasUserRated
                                      ? Text(
                                          S.current.pageBeachRated,
                                          style: GoogleFonts.adventPro(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        )
                                      : RatingBar(
                                          initialRating: 0.5,
                                          minRating: 0.5,
                                          allowHalfRating: true,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                          ratingWidget: RatingWidget(
                                            half: Icon(Icons.waves),
                                            full: Icon(
                                              Icons.waves,
                                              color: Colors.red,
                                            ),
                                            empty: Icon(Icons.waves),
                                          ),
                                          onRatingUpdate: (rating) async {
                                            log.wtf('rated $rating');
                                            await Api.instance.addRating(
                                              Rating(
                                                beachId: widget.beach!.id,
                                                rating: rating,
                                                review: 'test review',
                                                userUid: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                              ),
                                            );
                                            // setState(
                                            //   () {
                                            //     chosenRating = rating;
                                            //     addRating(
                                            //       Rating(
                                            //         beachId: widget.beach!.id,
                                            //         rating: rating,
                                            //         beachName:
                                            //             widget.beach!.name,
                                            //         userUid: FirebaseAuth
                                            //             .instance
                                            //             .currentUser!
                                            //             .uid,
                                            //         username: FirebaseAuth
                                            //             .instance
                                            //             .currentUser!
                                            //             .displayName,
                                            //       ),
                                            //     );
                                            //     hasUserRated = true;
                                            //     ratingSum = widget
                                            //             .beach!.averageRating! *
                                            //         widget.beach!.ratingCount!;
                                            //     actualRating =
                                            //         (ratingSum + rating) /
                                            //             (totalRatings + 1);
                                            //     totalRatings += 1;
                                            //   },
                                            // );
                                          },
                                          glowColor: Colors.blue,
                                        ),
                                ),
                              ),
                              Text(
                                chosenRating.toString(),
                                style: GoogleFonts.adventPro(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[50],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
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
                              widget.beach!.description!,
                              style: kStyleDefault,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12),
                            ),
                            child: GoogleMap(
                              markers: {beachMarker!},
                              myLocationButtonEnabled: false,
                              initialCameraPosition: beachPlace,
                              onMapCreated: _controller.complete,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
