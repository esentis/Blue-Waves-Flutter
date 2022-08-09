// ignore_for_file: use_build_context_synchronously

import 'package:blue_waves/constants.dart';
import 'package:blue_waves/pages/components/animated_background/abyss.dart';
import 'package:blue_waves/pages/components/animated_background/birds_stars.dart';
import 'package:blue_waves/pages/components/animated_background/sun_moon.dart';
import 'package:blue_waves/pages/components/animated_background/title.dart';
import 'package:blue_waves/pages/components/animated_background/waves.dart';
import 'package:blue_waves/states/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({
    Key? key,
    this.showTitle,
    this.showBack = false,
    this.waveHeight = WaveHeight.big,
    this.showBirds = true,
    this.showSun = true,
  }) : super(key: key);

  final bool? showTitle;
  final bool showBack;
  final bool showSun;
  final bool showBirds;
  final WaveHeight waveHeight;
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
          bottom: 0,
          left: 0,
          right: 0,
          child: Waves(
            height: widget.waveHeight,
          ),
        ),
        if (widget.showTitle ?? false)
          const SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: BlueWavesTitle(),
            ),
          )
        else
          const SizedBox(),
        const Abyss(),
        if (widget.showSun)
          Positioned(
            right: ThemeState.of(context, listen: true).isDark ? 30.w : 30.w,
            child: GestureDetector(
              onTap: () async {
                ThemeState.of(context).toggleTheme();
              },
              child: SafeArea(
                child: SunMoon(
                  isDark: ThemeState.of(context, listen: true).isDark,
                ),
              ),
            ),
          ),
        if (widget.showBirds)
          Positioned(
            top: ThemeState.of(context, listen: true).isDark ? -15 : -45,
            right: 0,
            left: 0,
            child: IgnorePointer(
              child: BirdsStars(
                isDark: ThemeState.of(context, listen: true).isDark,
              ),
            ),
          ),
        if (widget.showBack)
          Positioned(
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 50.w,
                height: 40.w,
                color: Colors.transparent,
                child: Icon(
                  Icons.arrow_back,
                  size: 30.w,
                  color: ThemeState.of(context, listen: true).isDark
                      ? kColorOrangeLight
                      : kColorBlueDark2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
