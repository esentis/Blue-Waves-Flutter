import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        height: 200.h,
        child: Lottie.network(
          'https://assets7.lottiefiles.com/packages/lf20_k6GHT3.json',
          animate: true,
          repeat: true,
          width: 250.w,
        ),
      ),
      secondCurve: Curves.easeInOut,
      secondChild: SizedBox(
        width: ScreenUtil().screenWidth,
        height: 200.h,
        child: Lottie.network(
          'https://assets2.lottiefiles.com/packages/lf20_dxry6ndt.json',
          animate: true,
          repeat: true,
          //width: 250.w,
        ),
      ),
    );
  }
}
