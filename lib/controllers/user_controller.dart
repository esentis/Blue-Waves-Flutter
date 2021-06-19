import 'package:Blue_Waves/models/Member.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

var usersRef = FirebaseDatabase.instance.reference().child('users');

/// Registers a user with the following parameters.
/// ### Member model
/// * displayName : String
/// * email : String
/// * password : String
/// * photoUrl : String
Future<void> registerUser(Member user) async {
  var userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: user.email!,
    password: user.password!,
  );
  await userCredential.user!.updateDisplayName(user.displayName);
  await userCredential.user!.updatePhotoURL(user.photoUrl ?? '');

  await usersRef.child(userCredential.user!.uid).set(
    {
      'username': user.displayName,
      'karma': 0,
      'role': 'user',
      'id': userCredential.user!.uid,
      'joinDate': DateFormat('dd-MM-yyy').format(DateTime.now()),
    },
  );
}
