import 'package:Blue_Waves/models/Beach.dart';
import 'package:Blue_Waves/models/Favorite.dart';
import 'package:Blue_Waves/models/Member.dart';
import 'package:Blue_Waves/models/Rating.dart';
import 'package:Blue_Waves/pages/components/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/mapping_extensions.dart';
import '../connection.dart';

// Beaches DB reference
CollectionReference beaches = FirebaseFirestore.instance.collection('beaches');

// Reviews DB reference
CollectionReference ratings = FirebaseFirestore.instance.collection('ratings');

// Users DB references
CollectionReference users = FirebaseFirestore.instance.collection('users');

// Favorites DB references
CollectionReference favorites =
    FirebaseFirestore.instance.collection('favorites');

/// Registers a user with the following parameters.
/// ### Member model
/// * displayName : String
/// * email : String
/// * password : String
/// * photoUrl : String
Future<void> registerUser(Member user) async {
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
    email: user.email,
    password: user.password,
  )
      .then((userCredential) {
    userCredential.user.updateProfile(
      displayName: user.displayName,
      photoURL: user.photoUrl ?? '',
    );
    users.add({
      'username': user.displayName,
      'karma': 0,
      'role': 'user',
      'id': userCredential.user.uid,
      'joinDate': DateFormat('dd-MM-yyy').format(DateTime.now()),
    }).then((docRef) async {
      // We add the document id as a field.
      await users.doc(docRef.id).update({'docId': docRef.id});
    });
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
  QuerySnapshot querySnapshot;
  var userDocId = '';
  // Checking if user has already reviewed the beach
  await ratings
      .where(
        'username',
        isEqualTo: rating.username,
      )
      .where('beachId', isEqualTo: rating.beachId)
      .get()
      .then((snapshot) => querySnapshot = snapshot);
  if (querySnapshot.docs.isNotEmpty) {
    return logger.e('You have already rated this beach');
  }

  // If we are ok to procceed we add the review.
  await ratings
      .add({
        'beachId': rating.beachId,
        'userId': rating.userUid,
        'username': rating.username,
        'rating': rating.rating,
        'beachName': rating.beachName,
        'date': DateFormat('dd-MM-yyy').format(DateTime.now()),
      })
      .then((value) => logger.i('Beach rating added'))
      .catchError((onError) => logger.e(onError));

  await users
      .where('id', isEqualTo: rating.userUid)
      .limit(1)
      .get()
      .then((value) => userDocId = value.docs.first.data()['docId']);
  // We award the user with karma points for rating a beach
  await users.doc(userDocId).update({'karma': FieldValue.increment(15)}).then(
    (value) {
      showSnack(
        title: 'Συγχαρητήρια',
        message: 'Κέρδισες 15 πόντους!',
        firstColor: Colors.orange,
        secondColor: Colors.blue,
      );
      logger.i(
        '${rating.username} got 15 karma points!',
      );
    },
  ).catchError((error) => logger.e(error));
}

Future<void> addFavorite(Favorite favorite) async {
  QuerySnapshot querySnapshot;
  DocumentReference docRef;
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
        .doc(querySnapshot.docs.first.data()['id'])
        .delete()
        .then((value) => logger.e('Favorite removed'));
    return logger.e('Beach removed from favorites.');
  }

  // If we are ok to procceed we add the review.
  await favorites.add({
    'beachId': favorite.beachId,
    'userId': favorite.userId,
    'beachName': favorite.beachName,
    'date': DateFormat('dd-MM-yyy').format(DateTime.now()),
  }).then((value) {
    logger.i('Beach added to favorites!');
    docRef = value;
  }).catchError((onError) => logger.e(onError));

  await favorites
      .doc(docRef.id)
      // ignore: unnecessary_string_interpolations
      .update({'id': '${docRef.id}'})
      .then((value) => logger.i('Favorite beach id UPDATED'))
      .catchError((onError) => logger.e(onError));
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
  QuerySnapshot beachQuery;
  DocumentReference documentReference;

  // Checking if there is already a beach with similar name
  await beaches
      .where('name', isEqualTo: beach.name)
      .get()
      .then((querySnapshot) => beachQuery = querySnapshot);
  if (beachQuery.docs.isNotEmpty) {
    return logger.w('Beach name already exists in database');
  }

  // If we are ok to procceed we add the beach.
  await beaches.add({
    'name': beach.name,
    'description': beach.description,
    'longitude': beach.longitude,
    'latitude': beach.latitude,
    'images': beach.images,
  }).then((docRef) {
    logger.i('Beach Added');
    documentReference = docRef;
  }).catchError((error) => logger.e('Failed to add beach: $error'));

  // We add the document's id to a seperate field to access it easily.
  await beaches
      .doc(documentReference.id)
      // ignore: unnecessary_string_interpolations
      .update({'id': '${documentReference.id}'})
      .then((value) => logger.i('Beach id UPDATED'))
      .catchError((onError) => logger.e(onError));
}

/// Gets all beaches from db, used only in homepage to draw markers on the map.
Future<List<Map<String, dynamic>>> getBeaches() async {
  var mappedBeaches =
      await beaches.get().then((querySnapshot) => querySnapshot.toBeach());

  return mappedBeaches;
}

/// Gets a beach with an ID
Future getBeach(String id) async {
  var beach = await beaches.doc(id).get().then((value) => value.data());
  logger.wtf(beach);
  return beach;
}
