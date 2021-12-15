import 'package:blue_waves/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

SnackbarController showSnack({
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
      style: kStyleDefaultBold.copyWith(
        color: const Color(0xff005295),
        fontSize: 25.sp,
      ),
    ),
    messageText: Text(
      message,
      textAlign: TextAlign.center,
      style: kStyleDefaultBold.copyWith(
        color: Colors.orange[50],
        fontSize: 20.sp,
      ),
    ),
    barBlur: 5,
  );
}
