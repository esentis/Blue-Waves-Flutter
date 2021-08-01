import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loader extends StatelessWidget {
  const Loader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
