import 'package:blue_waves/constants.dart';
import 'package:blue_waves/states/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

enum WaveHeight {
  small,
  big,
}

class Waves extends StatelessWidget {
  final WaveHeight height;
  const Waves({required this.height});

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context, listen: true);
    return Stack(
      children: [
        SizedBox(
          height: 660.h,
          child: WaveWidget(
            backgroundColor: Colors.transparent,
            config: CustomConfig(
              gradients: [
                [
                  if (themeState.isDark) kColorPurpleDark else kColorGreenArmy,
                  if (themeState.isDark) kColorBlack else kColorGreelLight2,
                ],
                [
                  if (themeState.isDark) kColorPurpleDark else kColorBlueLight,
                  if (themeState.isDark) kColorPurpleDark else kColorGreenArmy,
                ],
                [
                  if (themeState.isDark) kColorGreenArmy else kColorWhite,
                  if (themeState.isDark) kColorPurpleDark else kColorBlueLight,
                ],
                [
                  if (themeState.isDark) kColorGreenLight else kColorBlueLight,
                  if (themeState.isDark) kColorPurpleDark else kColorGreenArmy,
                ]
              ],
              durations: themeState.isDark
                  ? [35000, 40000, 45000, 55000]
                  : [35000, 19440, 10800, 6000],
              heightPercentages: height == WaveHeight.small
                  ? themeState.isDark
                      ? [0.6, 0.7, 0.9, 0.7]
                      : [0.6, 0.7, 0.9, 0.7]
                  : themeState.isDark
                      ? [0.02, 0.03, 0.04, 0.05]
                      : [0.01, 0.02, 0.01, 0.02],
              blur: const MaskFilter.blur(
                BlurStyle.inner,
                14,
              ),
              gradientBegin: Alignment.bottomLeft,
              gradientEnd: Alignment.topRight,
            ),
            waveFrequency: 0.9,
            size: Size.infinite,
          ),
        ),
      ],
    );
  }
}
