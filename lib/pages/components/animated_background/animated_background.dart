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
  }) : super(key: key);

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
          child: TropicalIsland(),
        ),
        Positioned(
          child: Waves(),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 13,
          left: MediaQuery.of(context).size.width / 4,
          child: BlueWavesTitle(),
        ),
        const Abyss(),
      ],
    );
  }
}
