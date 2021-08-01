import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'abyss.dart';
import 'birds_stars.dart';
import 'sun_moon.dart';
import 'title.dart';
import 'tropical_island.dart';
import 'waves.dart';

class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({
    Key? key,
    this.showTitle,
    this.isDark = true,
  }) : super(key: key);

  final bool? showTitle;
  final bool isDark;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: isDark ? const Color(0xff0F044C) : Colors.orange[100],
        ),
        Positioned(
          left: isDark ? 50.w : 30.w,
          child: SunMoon(
            isDark: isDark,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: BurdsStars(
            isDark: isDark,
          ),
        ),
        Positioned(
          top: 10.h,
          child: TropicalIsland(),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Waves(
            isDark: isDark,
          ),
        ),
        if (showTitle!)
          Align(alignment: Alignment.topCenter, child: BlueWavesTitle())
        else
          const SizedBox(),
        const Abyss(),
      ],
    );
  }
}
