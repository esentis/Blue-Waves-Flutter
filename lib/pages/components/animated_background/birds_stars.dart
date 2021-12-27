import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class BurdsStars extends StatelessWidget {
  final bool isDark;
  const BurdsStars({required this.isDark});
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 900),
      crossFadeState:
          isDark ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstCurve: Curves.easeInOut,
      firstChild: SizedBox(
        width: ScreenUtil().screenWidth,
        height: 250.h,
        child: Lottie.asset(
          'assets/images/birds.json',
          animate: true,
          repeat: true,
          width: ScreenUtil().screenWidth,
        ),
      ),
      secondCurve: Curves.easeInOut,
      secondChild: SizedBox(
        width: ScreenUtil().screenWidth,
        height: 200.h,
        child: Lottie.asset(
          'assets/images/stars.json',
          animate: true,
          repeat: true,
          //width: 250.w,
        ),
      ),
    );
  }
}
