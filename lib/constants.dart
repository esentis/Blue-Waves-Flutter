import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

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
  fontSize: 20,
  color: Colors.white,
);

TextStyle kStyleDefaultBold = GoogleFonts.adventPro(
  fontSize: 20,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);
