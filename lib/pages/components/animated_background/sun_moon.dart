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
      firstChild: Lottie.network(
        'https://assets8.lottiefiles.com/packages/lf20_sCwGNr.json',
        animate: true,
        repeat: true,
        width: 40.w,
      ),
      secondCurve: Curves.easeInOut,
      secondChild: Lottie.network(
        'https://assets10.lottiefiles.com/private_files/lf30_Um0Z9o.json',
        animate: true,
        repeat: true,
        width: 100.w,
      ),
    );
    // return Lottie.network(
    //   'https://assets8.lottiefiles.com/packages/lf20_sCwGNr.json',
    //   animate: true,
    //   repeat: true,
    //   width: 40.w,
    // );
  }
}
