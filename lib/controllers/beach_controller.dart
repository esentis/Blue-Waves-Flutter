import 'package:blue_waves_flutter/models/Beach.dart';
import 'package:blue_waves_flutter/models/Member.dart';
import 'package:blue_waves_flutter/models/Review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helpers/mapping_extensions.dart';
import '../connection.dart';

// Beaches DB reference
CollectionReference beaches = FirebaseFirestore.instance.collection('beaches');

// Reviews DB reference
CollectionReference reviews = FirebaseFirestore.instance.collection('reviews');

// Users DB references
CollectionReference users = FirebaseFirestore.instance.collection('users');

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
      'karmaPoints': 0,
      'role': 'user',
      'id': userCredential.user.uid,
      'reviews': [],
    });
  }).catchError((onError) => logger.e(onError));
}

/// Adds a review with the following parameters.
/// ### Review model
/// * beachId : String
/// * cons : String
/// * pros : String
/// * rating : int
/// * userID : String
/// * username : String
Future<void> addReview(Review review) async {
  QuerySnapshot querySnapshot;

  // Checking if user has already reviewed the beach
  await reviews
      .where(
        'username',
        isEqualTo: review.username,
      )
      .where('beachId', isEqualTo: review.beachId)
      .get()
      .then((snapshot) => querySnapshot = snapshot);
  if (querySnapshot.docs.isNotEmpty) {
    return logger.e('You have already reviewed this beach');
  }

  // If we are ok to procceed we add the review.
  await reviews
      .add({
        'beachId': review.beachId,
        'cons': review.cons,
        'pros': review.pros,
        'userID': review.userID,
        'username': review.username,
        'rating': review.rating,
      })
      .then((value) => logger.i('Beach review added'))
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
    'totalRatings': 0,
    'rating': 0,
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
