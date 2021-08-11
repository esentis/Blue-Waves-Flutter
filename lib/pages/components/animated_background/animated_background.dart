import 'package:blue_waves/constants.dart';
import 'package:blue_waves/states/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'abyss.dart';
import 'birds_stars.dart';
import 'sun_moon.dart';
import 'title.dart';
import 'waves.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({
    Key? key,
    this.showTitle,
    this.showBack = false,
  }) : super(key: key);

  final bool? showTitle;
  final bool showBack;
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
          child: Waves(),
        ),
        if (widget.showTitle!)
          Align(alignment: Alignment.topCenter, child: BlueWavesTitle())
        else
          const SizedBox(),
        const Abyss(),
        Positioned(
          right: ThemeState.of(context, listen: true).isDark ? 30.w : 30.w,
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
        Positioned(
          top: ThemeState.of(context, listen: true).isDark ? -15 : -45,
          right: 0,
          left: 0,
          child: IgnorePointer(
            child: BurdsStars(
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
