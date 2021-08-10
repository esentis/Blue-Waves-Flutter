import 'package:blue_waves/constants.dart';
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
          height: 660.h,
          child: WaveWidget(
            backgroundColor: Colors.transparent,
            config: CustomConfig(
              gradients: [
                [
                  if (isDark) kColorPurpleDark else kColorGreenLight,
                  if (isDark) kColorGreenArmy else kColorGreelLight2,
                ],
                [
                  if (isDark) kColorPurpleDark else kColorBlueLight,
                  if (isDark) kColorPurpleDark else kColorBlue,
                ],
                [
                  if (isDark) kColorBlack else kColorWhite,
                  if (isDark) kColorPurpleDark else kColorBlueLight,
                ],
                [
                  if (isDark) kColorGreenLight else kColorBlueLight,
                  if (isDark) kColorPurpleDark else kColorBlue,
                ]
              ],
              durations: isDark
                  ? [35000, 40000, 45000, 55000]
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
