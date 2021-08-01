import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Waves extends StatelessWidget {
  final bool isDark;
  const Waves({required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          // height: ScreenUtil().screenHeight * .5,
          height: 630.h,
          child: WaveWidget(
            backgroundColor: Colors.transparent,
            config: CustomConfig(
              gradients: [
                [
                  Colors.white,
                  const Color(0xff18A6EC),
                ],
                [
                  const Color(0xff18A6EC),
                  const Color(0xff005295),
                ],
                [
                  Colors.white,
                  const Color(0xff18A6EC),
                ],
                [
                  const Color(0xff18A6EC),
                  const Color(0xff005295),
                ]
              ],
              durations: isDark
                  ? [35000, 30000, 45000, 25000]
                  : [35000, 19440, 10800, 6000],
              heightPercentages:
                  isDark ? [0.02, 0.03, 0.04, 0.05] : [0.01, 0.02, 0.01, 0.02],
              blur: const MaskFilter.blur(
                BlurStyle.inner,
                14,
              ),
              gradientBegin: Alignment.bottomLeft,
              gradientEnd: Alignment.topRight,
            ),
            waveFrequency: 0.9,
            size: const Size(
              double.infinity,
              double.infinity,
            ),
          ),
        ),
      ],
    );
  }
}
