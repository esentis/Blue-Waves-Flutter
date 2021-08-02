import 'package:blue_waves/constants.dart';
import 'package:blue_waves/states/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'abyss.dart';
import 'birds_stars.dart';
import 'sun_moon.dart';
import 'title.dart';
import 'tropical_island.dart';
import 'waves.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({
    Key? key,
    this.showTitle,
  }) : super(key: key);

  final bool? showTitle;

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: ThemeState.of(context, listen: true).isDark
              ? const Color(0xff0F044C)
              : Colors.orange[100],
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: BurdsStars(
            isDark: ThemeState.of(context, listen: true).isDark,
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
            isDark: ThemeState.of(context, listen: true).isDark,
          ),
        ),
        if (widget.showTitle!)
          Align(alignment: Alignment.topCenter, child: BlueWavesTitle())
        else
          const SizedBox(),
        const Abyss(),
        Positioned(
          left: ThemeState.of(context, listen: true).isDark ? 50.w : 30.w,
          child: GestureDetector(
            onTap: () {
              ThemeState.of(context).toggleTheme();
              log.wtf('tapping weather');
            },
            child: SunMoon(
              isDark: ThemeState.of(context, listen: true).isDark,
            ),
          ),
        ),
      ],
    );
  }
}
