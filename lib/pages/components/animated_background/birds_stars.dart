import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class BirdsStars extends StatelessWidget {
  final bool isDark;
  const BirdsStars({required this.isDark});
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 900),
      crossFadeState:
          isDark ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstCurve: Curves.easeInOut,
      firstChild: SizedBox(
        width: 1.sw,
        height: 250.h,
        child: Lottie.asset(
          'assets/images/birds.json',
          animate: true,
          repeat: true,
          width: double.infinity,
        ),
      ),
      secondCurve: Curves.easeInOut,
      secondChild: SizedBox(
        width: double.infinity,
        height: 200.h,
        child: Lottie.asset(
          'assets/images/stars.json',
          animate: true,
          repeat: true,
        ),
      ),
    );
  }
}
