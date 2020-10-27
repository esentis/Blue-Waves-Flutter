import 'package:flutter/material.dart';

import 'abyss.dart';
import 'birds.dart';
import 'sun.dart';
import 'title.dart';
import 'tropical_island.dart';
import 'waves.dart';

class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({
    Key key,
    this.showTitle,
  }) : super(key: key);

  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.orange[50],
        ),
        Positioned(
          left: 50,
          child: Sun(),
        ),
        Positioned(
          top: 0,
          child: Birds(),
        ),
        Positioned(
          top: 10,
          child: TropicalIsland(),
        ),
        Positioned(
          child: Waves(),
        ),
        showTitle
            ? Align(alignment: Alignment.topCenter, child: BlueWavesTitle())
            : const SizedBox(),
        const Abyss(),
      ],
    );
  }
}
