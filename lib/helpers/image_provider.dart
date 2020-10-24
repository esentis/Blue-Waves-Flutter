// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class BWavesImage extends StatelessWidget {
//   const BWavesImage({
//     @required this.url,
//   });
//   final String url;

//   @override
//   Widget build(BuildContext context) {
//     return Hero(
//       tag: url,
//       child: ExtendedImage.network(
//         url,
//         cache: true,
//         // ignore: missing_return
//         loadStateChanged: (ExtendedImageState state) {
//           switch (state.extendedImageLoadState) {
//             case LoadState.loading:
//               return Container(
//                 width: double.infinity,
//                 child: Container(
//                   color: Colors.blue.withOpacity(0.2),
//                   child: Lottie.asset(
//                     'assets/images/loading.json',
//                   ),
//                 ),
//               );
//               break;

//             ///if you don't want override completed widget
//             ///please return null or state.completedWidget
//             //return null;
//             //return state.completedWidget;
//             case LoadState.completed:
//               return Container(
//                 child: ExtendedRawImage(
//                   image: state.extendedImageInfo?.image,
//                   fit: BoxFit.cover,
//                 ),
//               );
//               break;
//             case LoadState.failed:
//               return GestureDetector(
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: <Widget>[
//                     Image.asset(
//                       'assets/failed.jpg',
//                       fit: BoxFit.fill,
//                     ),
//                     const Positioned(
//                       bottom: 0.0,
//                       left: 0.0,
//                       right: 0.0,
//                       child: Text(
//                         'load image failed, click to reload',
//                         textAlign: TextAlign.center,
//                       ),
//                     )
//                   ],
//                 ),
//                 onTap: () {
//                   state.reLoadImage();
//                 },
//               );
//               break;
//           }
//         },
//       ),
//     );
//   }
// }
