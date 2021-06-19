import 'package:Blue_Waves/constants.dart';
import 'package:Blue_Waves/controllers/user_controller.dart';
import 'package:Blue_Waves/models/Beach.dart';
import 'package:Blue_Waves/models/Favorite.dart';
import 'package:Blue_Waves/models/Member.dart';
import 'package:Blue_Waves/models/Rating.dart';
import 'package:Blue_Waves/pages/components/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

// Beaches DB reference
var beaches = FirebaseDatabase.instance.reference().child('beaches');

// Reviews DB reference
var ratings = FirebaseDatabase.instance.reference().child('ratings');

// Favorites DB references
CollectionReference favorites =
    FirebaseFirestore.instance.collection('favorites');

// Neaches reference in Realtime Database
// var _beachesRef = FirebaseDatabase.instance.reference().child('beaches');

Stream<List<Beach>> getAllBeaches() {
  // ignore: omit_local_variable_types
  List<Beach> beaches = [];
  // ignore: omit_local_variable_types
  return FirebaseFirestore.instance
      .collection('beaches')
      .snapshots()
      .switchMap((qs) {
    qs.docs.forEach((element) {
      beaches.add(Beach.fromMap(element.data()));
    });
    return Stream.value(beaches);
  });
}

/// Adds a review with the following parameters.
/// ### Review model
/// * beachId : String
/// * cons : String
/// * pros : String
/// * rating : int
/// * userID : String
/// * username : String
Future<void> addRating(Rating rating) async {
  late QuerySnapshot querySnapshot;
  var userDocId = '';
  await ratings.once().then((snapshot) => log.wtf(snapshot.value));
  // Checking if user has already reviewed the beach
  // await ratings
  //     .where(
  //       'username',
  //       isEqualTo: rating.username,
  //     )
  //     .where('beachId', isEqualTo: rating.beachId)
  //     .get()
  //     .then((snapshot) => querySnapshot = snapshot);
  // if (querySnapshot.docs.isNotEmpty) {
  //   return log.e('You have already rated this beach');
  // }

  // If we are ok to procceed we add the review.
  await ratings
      .set({
        'beachId': rating.beachId,
        'userId': rating.userUid,
        'username': rating.username,
        'rating': rating.rating,
        'beachName': rating.beachName,
        'date': DateFormat('dd-MM-yyy').format(DateTime.now()),
      })
      .then((value) => log.i('Beach rating added'))
      .catchError((onError) => log.e(onError));
  var member = await usersRef
      .child(rating.userUid!)
      .once()
      .then((value) => Member.fromJson(value.value.cast<String, dynamic>()));

  log.wtf(member);

  // await usersRef.child(rating.userUid!).update(
  //   {
  //     'karma': 5,
  //   },
  // );
  // await users
  //     .where('id', isEqualTo: rating.userUid)
  //     .limit(1)
  //     .get()
  //     .then((value) => userDocId = value.docs.first['docId']);
  // // We award the user with karma points for rating a beach
  // await users.doc(userDocId).update({'karma': FieldValue.increment(15)}).then(
  //   (value) {
  //     showSnack(
  //       title: 'Συγχαρητήρια',
  //       message: 'Κέρδισες 15 πόντους!',
  //       firstColor: Colors.orange,
  //       secondColor: Colors.blue,
  //     );
  //     log.i(
  //       '${rating.username} got 15 karma points!',
  //     );
  //   },
  // ).catchError((error) => log.e(error));
}

Future<void> addFavorite(Favorite favorite) async {
  late QuerySnapshot querySnapshot;
  late DocumentReference docRef;
  // Checking if user has already favorited the beach
  await favorites
      .where(
        'userId',
        isEqualTo: favorite.userId,
      )
      .where('beachId', isEqualTo: favorite.beachId)
      .get()
      .then((snapshot) => querySnapshot = snapshot);

  if (querySnapshot.docs.isNotEmpty) {
    await favorites
        .doc(querySnapshot.docs.first['id'])
        .delete()
        .then((value) => log.e('Favorite removed'));
    return log.e('Beach removed from favorites.');
  }

  // If we are ok to procceed we add the review.
  await favorites.add({
    'beachId': favorite.beachId,
    'userId': favorite.userId,
    'beachName': favorite.beachName,
    'date': DateFormat('dd-MM-yyy').format(DateTime.now()),
  }).then((value) {
    log.i('Beach added to favorites!');
    docRef = value;
  }).catchError((onError) => log.e(onError));

  await favorites
      .doc(docRef.id)
      // ignore: unnecessary_string_interpolations
      .update({'id': '${docRef.id}'})
      .then((value) => log.i('Favorite beach id UPDATED'))
      .catchError((onError) => log.e(onError));
}

/// Adds a new beach with the following parameters.
/// ### Beach model
/// * name : String
/// * description : String
/// * latitude : double
/// * longitude : double
/// * images : List<String>
/// * id : String
Future<void> addBeach(Beach beach) async {
  late QuerySnapshot beachQuery;
  DocumentReference documentReference;

  // Checking if there is already a beach with similar name
  // await beaches
  //     .where('name', isEqualTo: beach.name)
  //     .get()
  //     .then((querySnapshot) => beachQuery = querySnapshot);
  // if (beachQuery.docs.isNotEmpty) {
  //   return log.w('Beach name already exists in database');
  // }

  // If we are ok to procceed we add the beach.
  await beaches.set({
    'name': beach.name,
    'description': beach.description,
    'longitude': beach.longitude,
    'latitude': beach.latitude,
    'images': beach.images,
  }).then((docRef) async {
    log.i('Beach Added');
    // await _beachesRef.child(documentReference.id).set({
    //   'name': beach.name,
    //   'description': beach.description,
    //   'longitude': beach.longitude,
    //   'latitude': beach.latitude,
    //   'images': beach.images,
    //   'id': documentReference.id,
    // });
  }).catchError((error) => log.e('Failed to add beach: $error'));
}

/// Gets a beach with an ID
// Future getBeach(String id) async {
//   var beach = await _beachesRef.child(id).once().then((snapshot) {
//     return snapshot.value;
//   });
//   return beach;
// }
