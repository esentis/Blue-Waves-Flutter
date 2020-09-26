import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class Waves extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaveWidget(
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
        durations: [35000, 19440, 10800, 6000],
        heightPercentages: [0.04, 0.05, 0.06, 0.07],
        blur: const MaskFilter.blur(
          BlurStyle.inner,
          14,
        ),
        gradientBegin: Alignment.bottomLeft,
        gradientEnd: Alignment.topRight,
      ),
      waveAmplitude: 0,
      size: const Size(
        double.infinity,
        double.infinity,
      ),
    );
  }
}
