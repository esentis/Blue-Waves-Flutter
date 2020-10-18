import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  const Loader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Transform.scale(
        scale: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/images/loading.json'),
            Text(
              'Loading...!',
              textAlign: TextAlign.center,
              style: GoogleFonts.adventPro(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
