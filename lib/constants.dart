import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef Json = Map<String, dynamic>;

BaseOptions blueWavesOptions = BaseOptions(
    baseUrl: 'http://10.0.2.2:3000/',
    receiveDataWhenStatusError: true,
    connectTimeout: 6 * 1000, // 6 seconds
    receiveTimeout: 6 * 1000, // 6 seconds
    headers: {
      'Authorization': dotenv.env['API_KEY'],
    });

Logger log = Logger();

///```dart
/// fontSize: 20.sp,
/// color: kColorWhite,
///```
TextStyle kStyleDefault = GoogleFonts.adventPro(
  fontSize: 20.sp,
  color: kColorWhite,
);

///```dart
/// fontSize: 20.sp,
/// color: kColorWhite,
/// fontWeight: FontWeight.bold
///```
TextStyle kStyleDefaultBold = GoogleFonts.adventPro(
  fontSize: 20.sp,
  color: kColorWhite,
  fontWeight: FontWeight.bold,
);

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

Future<UserCredential?> googleSign() async {
  try {
    // Trigger the authentication flow
    final googleUser = await googleSignIn.signIn();
    // Obtain the auth details from the request
    final googleAuth = await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth!.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    final user = await FirebaseAuth.instance.signInWithCredential(credential);
    return user;
  } catch (error) {
    log.e(error);
  }
}

/// ```dart
///  const Color(0xff252525);
/// ```
Color kColorBlack = const Color(0xff252525);

/// ```dart
/// const Color(0xff081422);
/// ```
Color kColorBlueDark2 = const Color(0xff081422);

/// ```dart
/// const Color(0xff150485);
/// ```
Color kColorBlueDark = const Color(0xff150485);

/// ```dart
/// const Color(0xff31326F);
/// ```
Color kColorPurpleDark = const Color(0xff31326F);

/// ```dart
/// const Color(0xff005295);
/// ```
Color kColorBlue = const Color(0xff005295);

/// ```dart
/// const Color(0xff34626C);
/// ```
Color kColorGreenArmy = const Color(0xff34626C);

/// ```dart
/// const Color(0xff1AA6B7);
/// ```
Color kColorBlueLight = const Color(0xff1AA6B7);

/// ```dart
/// const Color(0xff18A6EC);
/// ```
Color kColorBlueLight2 = const Color(0xff18A6EC);

/// ```dart
/// const Color(0xff709FB0);
/// ```
Color kColorGreenLight = const Color(0xff709FB0);

/// ```dart
/// const Color(0xff9DDAC6);
/// ```
Color kColorGreelLight2 = const Color(0xff9DDAC6);

/// ```dart
/// const Color(0xffEAA819);
/// ```
Color kColorOrange = const Color(0xffEAA819);

/// ```dart
/// Colors.orange[200];
/// ```
Color? kColorOrangeLight2 = Colors.orange[200];

/// ```dart
/// Colors.orange[50];
/// ```
Color? kColorOrangeLight = Colors.orange[50];

/// ```dart
/// const Color(0xffF9F9F9);
/// ```
Color kColorWhite = const Color(0xffF9F9F9);
