// import 'package:blue_waves_flutter/models/Beach.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../helpers/mapping_extensions.dart';
// import '../connection.dart';

// // Create a CollectionReference called users that references the firestore collection
// CollectionReference beaches = FirebaseFirestore.instance.collection('beaches');

// Future<void> addBeach(Beach beach) async {
//   QuerySnapshot beachQuery;
//   await beaches
//       .where('name', isEqualTo: beach.name)
//       .get()
//       .then((querySnapshot) => beachQuery = querySnapshot);
//   if (beachQuery.docs.isNotEmpty) {
//     return logger.w('Beach name already exists in database');
//   }
//   return beaches
//       .add({
//         'name': beach.name,
//         'description': beach.description,
//         'longitude': beach.latitude,
//         'latitude': beach.longitude,
//       })
//       .then((value) => logger.i('Beach Added'))
//       .catchError((error) => logger.e('Failed to add beach: $error'));
// }

// Future<void> getBeaches() async {
//   var mappedBeaches = await beaches
//       .orderBy('name')
//       .startAfter(['Flutter'])
//       .limit(5)
//       .get()
//       .then((querySnapshot) => querySnapshot.toBeach());
//   logger.i(mappedBeaches);
//   return mappedBeaches;
// }
