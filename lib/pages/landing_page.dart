import 'dart:async';
import 'dart:typed_data';

import 'package:blue_waves_flutter/controllers/beach_controller.dart';
import 'package:blue_waves_flutter/pages/beach_page.dart';
import 'package:blue_waves_flutter/pages/components/animated_background/animated_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blue_waves_flutter/connection.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future redirectUser() async {
    await Navigator.popAndPushNamed(context, '/home');
  }

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((User user) {
      if (user == null) {
        logger.w('User is currently signed out');
      } else {
        logger.w('${user.displayName} is signed in ');
        redirectUser();
      }
    });
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
