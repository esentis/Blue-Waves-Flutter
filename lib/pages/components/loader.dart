import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.transparent,
      child: Transform.scale(
        scale: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/images/loading.json'),
            Text(
              S.current.loading,
              textAlign: TextAlign.center,
              style: kStyleDefaultBold.copyWith(
                fontSize: 60.sp,
              ),
            )
          ],
        ),
      ),
    );
  }
}
