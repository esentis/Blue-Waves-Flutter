import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlueWavesTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Blue ',
        style: GoogleFonts.adventPro(
          fontWeight: FontWeight.bold,
          fontSize: 45,
          color: const Color(0xff18A6EC),
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Waves',
            style: GoogleFonts.adventPro(
              fontWeight: FontWeight.bold,
              fontSize: 45,
              color: const Color(0xff005295),
            ),
          ),
        ],
      ),
    );
  }
}
