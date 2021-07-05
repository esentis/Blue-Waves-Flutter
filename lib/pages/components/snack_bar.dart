import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void showSnack({
  required String title,
  required String message,
  int duration = 1300,
  Color firstColor = Colors.white,
  Color secondColor = Colors.white,
}) {
  return Get.snackbar(
    '',
    '',
    duration: Duration(
      milliseconds: duration,
    ),
    backgroundColor: Colors.orange[50],
    backgroundGradient: LinearGradient(colors: [
      firstColor,
      secondColor,
    ]),
    titleText: Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.adventPro(
        color: const Color(0xff005295),
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    messageText: Text(
      message,
      textAlign: TextAlign.center,
      style: GoogleFonts.adventPro(
        color: Colors.orange[50],
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    barBlur: 5,
  );
}
