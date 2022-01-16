import 'dart:ui';

import 'package:blue_waves/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlueWavesTitle extends StatelessWidget {
  const BlueWavesTitle({this.isBlurred = false});
  final bool isBlurred;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: isBlurred ? 5 : 0,
          sigmaY: isBlurred ? 5 : 0,
        ),
        child: Container(
          color: isBlurred ? Colors.black.withOpacity(0.2) : Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 4.0.h,
              horizontal: 14.w,
            ),
            child: RichText(
              text: TextSpan(
                text: 'Blue ',
                style: kStyleDefaultBold.copyWith(
                  fontSize: 45.sp,
                  color: kColorBlue,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Waves',
                    style: kStyleDefaultBold.copyWith(
                      fontSize: 45.sp,
                      color: kColorBlueLight2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
