import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';

import 'components/animated_background/animated_background.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> checkUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await Get.offAllNamed('/home');
    }
  }

  @override
  void initState() {
    super.initState();

    // EXECUTES AFTER BUILD
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      checkUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: FadeIn(
            duration: const Duration(milliseconds: 700),
            child: Stack(
              children: [
                const AnimatedBackground(
                  showTitle: true,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          S.current.register,
                          style: kStyleDefault,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          S.current.login,
                          style: kStyleDefault,
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
