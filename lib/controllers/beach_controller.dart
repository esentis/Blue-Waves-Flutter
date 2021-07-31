import 'package:blue_waves/constants.dart';
import 'package:blue_waves/models/beach.dart';
import 'package:blue_waves/models/rating.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

import 'package:intl/intl.dart';

Uuid uuid = const Uuid();
// Beaches DB reference
DatabaseReference beaches =
    FirebaseDatabase.instance.reference().child('beaches');

// Reviews DB reference
DatabaseReference ratings =
    FirebaseDatabase.instance.reference().child('ratings');

// Favorites DB references
DatabaseReference favorites =
    FirebaseDatabase.instance.reference().child('favorites');

// Neaches reference in Realtime Database
// var _beachesRef = FirebaseDatabase.instance.reference().child('beaches');

// Future<List<Beach>> getAllBeaches() async {
//   final List<Beach> listBeaches = [];
//   // ignore: omit_local_variable_types
//   await beaches.once().then(
//     (value) {
//       final mappedBeaches =
//           Map<String, dynamic>.from(value as Map<String, dynamic>);
//       mappedBeaches.forEach((key, value) {
//         listBeaches.add(Beach.fromMap(value as Map<String, dynamic>));
//       });
//     },
//   );
//   return listBeaches;
// }

// Future<Beach> getBeach(String id) async {
//   final beach = await beaches
//       .child(id)
//       .once()
//       .then((value) => Beach.fromMap(value.value as Map<String, dynamic>));
//   return beach;
// }

/// Adds a review with the following parameters.
/// ### Review model
/// * beachId : String
/// * cons : String
/// * pros : String
/// * rating : int
/// * userID : String
/// * username : String
// Future<void> addRating(Rating rating) async {
//   final rate = await ratings
//       .child(rating.beachId! + rating.userUid!)
//       .once()
//       .then((snapshot) => snapshot.value);

//   // If user already rated the beach we break the flow
//   if (rate != null) {
//     return log.e('Beach already rated');
//   }

//   // If we are ok to procceed we add the review.
//   await ratings
//       .child(rating.beachId! + rating.userUid!)
//       .set({
//         'beachId': rating.beachId,
//         'userId': rating.userUid,
//         'username': rating.username,
//         'rating': rating.rating,
//         'beachName': rating.beachName,
//         'date': DateFormat('dd-MM-yyy').format(DateTime.now()),
//       })
//       .then((value) => log.i('Beach rating added'))
//       .catchError((onError) => log.e(onError));

// // Update beach average rating and total rating count
//   final beach = await beaches
//       .child(rating.beachId!)
//       .once()
//       .then((value) => Beach.fromMap(value.value as Map<String, dynamic>));
//   if (beach.ratingCount != null) {
//     var currentSum = beach.averageRating! * beach.ratingCount!;
//     currentSum += rating.rating!;
//     beach.ratingCount = beach.ratingCount! + 1;

//     beach.averageRating = currentSum / beach.ratingCount!;
//   } else {
//     beach.ratingCount = 1;
//     beach.averageRating = rating.rating;
//   }
//   await beaches.child(beach.id!).update(beach.toMap());

//   /// Adds a new beach with the following parameters.
//   /// ### Beach model
//   /// * name : String
//   /// * description : String
//   /// * latitude : double
//   /// * longitude : double
//   /// * images : List<String>
//   /// * id : String
//   // Future<void> addBeach(Beach beach) async {
//   //   // If we are ok to procceed we add the beach.
//   //   await beaches.child(uuid.v1()).set({
//   //     'name': beach.name,
//   //     'description': beach.description,
//   //     'longitude': beach.longitude,
//   //     'latitude': beach.latitude,
//   //     'images': beach.images,
//   //   }).then((docRef) async {
//   //     log.i('Beach Added');
//   //   }).catchError((error) => log.e('Failed to add beach: $error'));
//   // }
// }
