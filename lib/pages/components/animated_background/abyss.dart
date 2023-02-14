import 'package:blue_waves/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Abyss extends StatelessWidget {
  const Abyss({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 200.h),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black,
              kColorBlueDark.withOpacity(0.5),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
