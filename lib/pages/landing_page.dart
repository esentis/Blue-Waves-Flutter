import 'package:blue_waves_flutter/pages/components/animated_background/animated_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FadeIn(
            duration: const Duration(milliseconds: 700),
            child: Stack(
              children: [
                const AnimatedBackground(),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Register',
                          style: GoogleFonts.adventPro(
                            fontSize: 35,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Sign in',
                          style: GoogleFonts.adventPro(
                            fontSize: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
