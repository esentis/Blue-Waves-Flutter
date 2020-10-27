import 'dart:async';
import 'package:Blue_Waves/controllers/beach_controller.dart';
import 'package:Blue_Waves/models/Favorite.dart';
import 'package:Blue_Waves/models/Rating.dart';
import 'package:Blue_Waves/pages/components/snack_bar.dart';
import 'package:animate_do/animate_do.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../connection.dart';
import 'beach_image_wrapper.dart';
import 'components/animated_background/animated_background.dart';
import 'components/loader.dart';

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
  bool hasUserRated = false;
  bool isBeachFavorited = false;
  double ratingSum = 0;
  double actualRating = 0;
  List foundRatings = [];
  int totalRatings = 0;
  double chosenRating = 0.5;
  int currentIndex = 0;
  bool verticalGallery = false;
  bool isLoading = true;

  final PageController _pageController = PageController();

  void open(BuildContext context, int index) async {
    await Get.to(
      GalleryPhotoViewWrapper(
        images: widget.beach['images'],
        backgroundDecoration: const BoxDecoration(
          color: Color(0xff005295),
        ),
        initialIndex: index,
        scrollDirection: verticalGallery ? Axis.vertical : Axis.horizontal,
      ),
    );
  }

  Future getRatings() async {
    await ratings
        .where('beachId', isEqualTo: widget.beach['id'])
        .get()
        .then((value) => foundRatings = value.docs);

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

    if (foundRatings.isNotEmpty) {
      logger.wtf('Ratings found iterating on them');
      foundRatings.forEach((element) {
        ratingSum += element['rating'];
        if (element['username'] ==
            FirebaseAuth.instance.currentUser.displayName) {
          chosenRating = element['rating'];
        }
      });
      actualRating = ratingSum / foundRatings.length;
      totalRatings = foundRatings.length;
    }

    logger.i('Found ${foundRatings.length} reviews');
    logger.i('Actual rating is $actualRating');

    hasUserRated = foundRatings.any((element) =>
        element['username'] == FirebaseAuth.instance.currentUser.displayName);

    logger.i('Has user reviewed the beach ? $hasUserRated');
    isLoading = false;
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

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getRatings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const AnimatedBackground(
              showTitle: false,
            ),
            isLoading
                ? const Loader()
                : FadeIn(
                    duration: const Duration(milliseconds: 700),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        elevation: 25,
                        leading: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.blue,
                            size: 40,
                          ),
                        ),
                        shadowColor: Colors.black,
                        toolbarHeight: MediaQuery.of(context).size.height / 10,
                        backgroundColor: Colors.orange[50].withOpacity(0.8),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.beach['name'],
                                  style: GoogleFonts.adventPro(
                                    fontSize: 25,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await addFavorite(
                                      Favorite(
                                        beachId: widget.beach['id'],
                                        beachName: widget.beach['name'],
                                        userId: FirebaseAuth
                                            .instance.currentUser.uid,
                                      ),
                                    );
                                    setState(() {
                                      if (isBeachFavorited) {
                                        isBeachFavorited = false;
                                        showSnack(
                                            title:
                                                'Αφαιρέθηκε απο τα αγαπημένα',
                                            duration: 1500,
                                            firstColor:
                                                Colors.red.withOpacity(0.6),
                                            secondColor: Colors.blue,
                                            message:
                                                'Η παραλία αφαιρέθηκε απο τη λιστα με τις αγαπημένες σας παραλίες');
                                      } else {
                                        showSnack(
                                            title: 'Προστέθηκε στα αγαπημενα',
                                            duration: 1500,
                                            firstColor:
                                                Colors.green.withOpacity(0.6),
                                            secondColor: Colors.blue,
                                            message:
                                                'Μπορείτε να βρείτε τη λίστα με τις αγαπημένες σας παραλίες στο προφίλ σας.');
                                        isBeachFavorited = true;
                                      }
                                    });
                                  },
                                  child: isBeachFavorited
                                      ? const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 50,
                                        )
                                      : Icon(
                                          Icons.favorite,
                                          color: Colors.orange[50],
                                          size: 50,
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
                              child: Container(
                                color: Colors.transparent,
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height / 4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: PhotoViewGallery.builder(
                                    scrollPhysics:
                                        const BouncingScrollPhysics(),
                                    builder: (BuildContext context, int index) {
                                      return PhotoViewGalleryPageOptions(
                                        imageProvider: NetworkImage(
                                          widget.beach['images'][index],
                                        ),
                                        minScale:
                                            PhotoViewComputedScale.contained,
                                        initialScale:
                                            PhotoViewComputedScale.covered,
                                        tightMode: true,
                                        onTapDown: (context, details,
                                            controllerValue) {
                                          open(context, index);
                                        },
                                        heroAttributes: PhotoViewHeroAttributes(
                                            tag: widget.beach['images'][index]),
                                      );
                                    },
                                    itemCount: widget.beach['images'].length,
                                    loadingBuilder: (context, event) => Center(
                                      child: Container(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(
                                          value: event == null
                                              ? 0
                                              : event.cumulativeBytesLoaded /
                                                  event.expectedTotalBytes,
                                        ),
                                      ),
                                    ),
                                    pageController: _pageController,
                                    onPageChanged: (index) {},
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Rating : $actualRating out of $totalRatings ',
                              style: GoogleFonts.adventPro(
                                fontSize: 25,
                                color: Colors.orange[50],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: hasUserRated
                                          ? Text(
                                              'Έχεις ήδη βαθμολογήσει με :',
                                              style: GoogleFonts.adventPro(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            )
                                          : RatingBar(
                                              initialRating: 0.5,
                                              minRating: 0.5,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemSize: 40,
                                              itemCount: 5,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.waves,
                                                color: Colors.blue,
                                              ),
                                              onRatingUpdate: (rating) {
                                                setState(() {
                                                  chosenRating = rating;
                                                  addRating(
                                                    Rating(
                                                      beachId:
                                                          widget.beach['id'],
                                                      rating: rating,
                                                      beachName:
                                                          widget.beach['name'],
                                                      userUid: FirebaseAuth
                                                          .instance
                                                          .currentUser
                                                          .uid,
                                                      username: FirebaseAuth
                                                          .instance
                                                          .currentUser
                                                          .displayName,
                                                    ),
                                                  );
                                                  hasUserRated = true;
                                                  actualRating =
                                                      (ratingSum + rating) /
                                                          (totalRatings + 1);
                                                  totalRatings += 1;
                                                });
                                              },
                                              glow: true,
                                              glowColor: Colors.blue,
                                            ),
                                    ),
                                  ),
                                  Text(
                                    chosenRating.toString() ?? '',
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
                                  widget.beach['description'],
                                  style: GoogleFonts.adventPro(
                                    fontSize: 22,
                                    color: Colors.orange[50],
                                  ),
                                ),
                              ),
                            ),
                            Container(
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
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                  },
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
