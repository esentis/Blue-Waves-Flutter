// ignore_for_file: dead_code

import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:blue_waves/api/api_service.dart';
import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/models/beach.dart';
import 'package:blue_waves/models/photo.dart';
import 'package:blue_waves/pages/beach_page/beach_image_wrapper.dart';
import 'package:blue_waves/pages/components/loader.dart';
import 'package:blue_waves/states/loading_state.dart';
import 'package:blue_waves/states/theme_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:string_extensions/string_extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BeachPage extends StatefulWidget {
  const BeachPage({required this.beach});
  final Beach beach;
  @override
  _BeachPageState createState() => _BeachPageState();
}

class _BeachPageState extends State<BeachPage> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  late CameraPosition beachPlace;

  final PageController _imageController = PageController(viewportFraction: 0.8);
  Marker? beachMarker;

  double? chosenRating;
  double ratingSum = 0;
  double actualRating = 0;

  List<Photo> images = [];

  int totalRatings = 0;
  int currentIndex = 1;

  bool hasUserRated = false;
  bool verticalGallery = false;
  bool isLoading = false;
  bool isBeachFavorited = false;

  String? _mapStyle;

  Future<void> open(BuildContext context, int index) async {
    await Get.to(
      () => GalleryPhotoViewWrapper(
        images: images,
        backgroundDecoration: const BoxDecoration(
          color: Color(0xff005295),
        ),
        initialIndex: index,
        scrollDirection: verticalGallery ? Axis.vertical : Axis.horizontal,
      ),
    );
  }

  Future<void> setMapStyle() async {
    _mapStyle = ThemeState.of(context).isDark
        ? await rootBundle.loadString('map_styles.txt')
        : await rootBundle.loadString('map_styles_light.txt');

    if (!mounted) return;
    if (LoadingState.of(context).isLoading!) {
      LoadingState.of(context).toggleLoading();
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    beachPlace = CameraPosition(
      target: LatLng(widget.beach.latitude!, widget.beach.longitude!),
      zoom: 14.4746,
    );
    beachMarker = Marker(
      markerId: const MarkerId('beachMarker'),
      position: LatLng(widget.beach.latitude!, widget.beach.longitude!),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await setMapStyle();
      images = await Api.instance.getImages(widget.beach.id);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeState.of(context, listen: true).isDark
          ? kColorBlueDark2.withOpacity(0.5)
          : kColorGreelLight2.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: ThemeState.of(context, listen: true).isDark
            ? kColorBlueDark2.withOpacity(0.5)
            : kColorGreelLight2.withOpacity(0.9),
        centerTitle: true,
        title: SelectableText(
          widget.beach.name ?? '',
          style: kStyleDefault.copyWith(
            fontSize: 23.sp,
            color: ThemeState.of(context, listen: true).isDark
                ? kColorOrangeLight
                : kColorBlueDark2,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            if (isLoading)
              const Loader()
            else
              FadeIn(
                duration: const Duration(milliseconds: 700),
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeState.of(context, listen: true).isDark
                        ? kColorBlueDark2.withOpacity(0.5)
                        : kColorGreelLight2.withOpacity(0.9),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (false)
                          Column(
                            children: [
                              SizedBox(
                                height: 25.h,
                              ),
                              Text(
                                '${S.current.pageBeachRating} ${actualRating.toStringAsFixed(1)} / 5',
                                style: kStyleDefault.copyWith(
                                  fontSize: 16.sp,
                                  color: ThemeState.of(context, listen: true)
                                          .isDark
                                      ? kColorOrangeLight
                                      : kColorBlueDark2,
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                ' ($totalRatings ${S.current.pageBeachRatings})',
                                style: kStyleDefault.copyWith(
                                  fontSize: 14.sp,
                                  color: ThemeState.of(context, listen: true)
                                          .isDark
                                      ? kColorOrangeLight
                                      : kColorBlueDark2,
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 10.h,
                        ),
                        if (false)
                          if (FirebaseAuth.instance.currentUser != null)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.0.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: hasUserRated
                                          ? Text(
                                              S.current.pageBeachRated,
                                              style: kStyleDefault.copyWith(
                                                fontSize: 16.sp,
                                                color: Colors.red,
                                              ),
                                            )
                                          : RatingBar.builder(
                                              initialRating: 0.5,
                                              minRating: 0.5,
                                              allowHalfRating: true,
                                              itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0.w,
                                              ),
                                              itemBuilder: (context, index) =>
                                                  Image.asset(
                                                'assets/images/sea.png',
                                                color: Colors.orange,
                                              ),
                                              onRatingUpdate: (rating) async {
                                                log.wtf('rated $rating');
                                                // await Api.instance.addRating(
                                                //   Rating(
                                                //     beachId: widget.beach!.id,
                                                //     rating: rating,
                                                //     review: 'test review',
                                                //     userUid: FirebaseAuth
                                                //         .instance
                                                //         .currentUser!
                                                //         .uid,
                                                //   ),
                                                // );
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
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    chosenRating?.toString() ?? 'N/A',
                                    style: kStyleDefault.copyWith(
                                      fontSize: 25.sp,
                                      color: Colors.orange[50],
                                    ),
                                  )
                                ],
                              ),
                            ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: ThemeState.of(context, listen: true).isDark
                                ? kColorBlueDark2.withOpacity(0.5)
                                : kColorGreelLight2,
                            boxShadow: [kSmallShadow],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.0.h,
                              horizontal: 8.0.w,
                            ),
                            child: SelectableText(
                              widget.beach.description ?? '',
                              style: kStyleDefault.copyWith(
                                height: 1.7,
                                color:
                                    ThemeState.of(context, listen: true).isDark
                                        ? kColorOrangeLight
                                        : kColorPurpleDark,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 1.sw,
                          height: 250.h,
                          child: PageView(
                            controller: _imageController,
                            children: [
                              for (var i = 0; i < images.length; i++)
                                Padding(
                                  padding: EdgeInsets.all(8.0.r),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await open(context, i);
                                    },
                                    child: Hero(
                                      tag: images[i].url.toString(),
                                      child: Container(
                                        width: 250.w,
                                        height: 150.h,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            kSmallShadow,
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              images[i].url.toString(),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                        // Source button
                        TextButton(
                          onPressed: () {
                            Get.to(
                              () => Scaffold(
                                appBar: AppBar(
                                  title: Text(
                                    '${widget.beach.name} ${S.current.source}',
                                    style: kStyleDefault.copyWith(
                                      fontSize: 23.sp,
                                      color:
                                          ThemeState.of(context, listen: true)
                                                  .isDark
                                              ? kColorOrangeLight
                                              : kColorBlueDark2,
                                    ),
                                  ),
                                  backgroundColor:
                                      ThemeState.of(context, listen: true)
                                              .isDark
                                          ? kColorBlueDark2.withOpacity(0.5)
                                          : kColorGreelLight2.withOpacity(0.9),
                                  centerTitle: true,
                                ),
                                body: WebView(
                                  initialUrl:
                                      widget.beach.descriptionSource.toString(),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            S.current.source.toTitleCase!,
                            style: kStyleDefaultBold.copyWith(
                              fontSize: 25.sp,
                              color: ThemeState.of(context, listen: true).isDark
                                  ? kColorGreenLight
                                  : kColorBlueDark2,
                            ),
                          ),
                        ),
                        // Map location
                        SizedBox(
                          width: ScreenUtil().screenWidth,
                          height: 250.h,
                          child: GoogleMap(
                            markers: {beachMarker!},
                            myLocationButtonEnabled: false,
                            initialCameraPosition:
                                beachPlace, //      mapController.setMapStyle(_mapStyle);
                            onMapCreated: (GoogleMapController controller) {
                              mapController = controller;
                              mapController.setMapStyle(_mapStyle);
                              _controller.complete(controller);
                            },
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
