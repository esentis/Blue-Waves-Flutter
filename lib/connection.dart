import 'package:blue_waves_flutter/models/BeachModel.dart';
import 'package:blue_waves_flutter/models/MemberModel.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

var logger = Logger();

BaseOptions httpOptions = BaseOptions(
    baseUrl: 'http://10.0.2.2:5000/',
    receiveDataWhenStatusError: true,
    connectTimeout: 6 * 1000, // 6 seconds
    receiveTimeout: 6 * 1000,
    headers: {'Content-Type': 'application/json'} // 6 seconds
    );
Dio blueWavesHttp = Dio(httpOptions);

/// Returns all beaches.
Future getBeaches() async {
  Response response;
  try {
    response = await blueWavesHttp.get('api/beach', queryParameters: {
      'page': 1,
      'itemsPerPage': 10,
    });
    logger.i('Getting all beaches.');
    logger.i(response.data);
  } on DioError catch (e) {
    logger.i(e);
    return e.type;
  }
  return response.data;
}

/// Adds a beach. [beach] has Name, Description , Latitude and Longitude
Future addBeach(Beach beach) async {
  Response response;
  try {
    response = await blueWavesHttp.post('api/beach', data: {
      'name': beach.name,
      'description': beach.description,
      'latitude': beach.latitude,
      'longitude': beach.longitute,
    });
    logger.i('Adding beach.');
    logger.i(response.data);
  } on DioError catch (e) {
    logger.i(e.response.data);
    return e;
  }
  return response.data;
}

/// Registers a member. [rMember] has Username, Email, Password and ConfirmPassword
Future registerMember(Member rMember) async {
  UserCredential user;
  try {
    user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: rMember.email, password: rMember.password);
    await user.user.updateProfile(
        displayName: rMember.displayName, photoURL: rMember.photoUrl);
    logger.i('Registering user.');
    logger.i(user.user);
  } catch (e) {
    logger.i(e.toString());
    return e;
  }
}

/// Registers a member. [rMember] has Username, Email, Password and ConfirmPassword
Future signInMember(Member rMember) async {
  UserCredential user;
  try {
    user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: rMember.email, password: rMember.password);

    logger.i('Logging user.');
    logger.i(user.user);
  } catch (e) {
    logger.i(e.toString());
    return e;
  }
}

Future signOutMember() async {
  await FirebaseAuth.instance.signOut();
}
