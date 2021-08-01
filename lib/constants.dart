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
TextStyle kStyleDefault = GoogleFonts.adventPro(
  fontSize: 20.sp,
  color: Colors.white,
);

TextStyle kStyleDefaultBold = GoogleFonts.adventPro(
  fontSize: 20.sp,
  color: Colors.white,
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
