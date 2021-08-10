import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SunMoon extends StatelessWidget {
  final bool isDark;
  const SunMoon({required this.isDark});
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 900),
      crossFadeState:
          isDark ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstCurve: Curves.easeInOut,
      firstChild: Lottie.asset(
        'assets/images/moon.json',
        animate: true,
        repeat: true,
        width: 40.w,
      ),
      secondCurve: Curves.easeInOut,
      secondChild: Lottie.asset(
        'assets/images/sun.json',
        animate: true,
        repeat: true,
        width: 40.w,
      ),
    );
  }
}
