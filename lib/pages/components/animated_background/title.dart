import 'package:blue_waves/pages/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BlueWavesTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        await FirebaseAuth.instance.signOut();
        await Get.offAll(() => LandingPage());
      },
      child: RichText(
        text: TextSpan(
          text: 'Blue ',
          style: GoogleFonts.adventPro(
            fontWeight: FontWeight.bold,
            fontSize: 45,
            color: const Color(0xff005295),
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Waves',
              style: GoogleFonts.adventPro(
                fontWeight: FontWeight.bold,
                fontSize: 45,
                color: const Color(0xff18A6EC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
