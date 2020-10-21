import 'package:animate_do/animate_do.dart';
import 'package:blue_waves_flutter/controllers/beach_controller.dart';
import 'package:blue_waves_flutter/models/Member.dart';
import 'package:blue_waves_flutter/pages/register_page/components/blue_waves_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:string_extensions/string_extensions.dart';

import '../connection.dart';
import 'components/animated_background/animated_background.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var usernameController = TextEditingController();
    void checkCredentials() {
      if (!emailController.text.isMail()) {
        return logger.i('Email is not valid');
      }
      registerUser(Member(
        displayName: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
      ));
      Navigator.popAndPushNamed(context, '/');
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: FadeIn(
        duration: const Duration(milliseconds: 700),
        child: Stack(children: [
          const AnimatedBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BWTextField(
                  emailController: emailController,
                  labelText: 'Email',
                ),
                BWTextField(
                  emailController: passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await auth.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);
                      await Navigator.popAndPushNamed(context, '/');
                    } catch (e) {
                      logger.e(e);
                    }
                  },
                  child: Text(
                    'Sign in',
                    style: GoogleFonts.adventPro(
                      fontSize: 35,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/');
                  },
                  child: Text(
                    'Επιστροφή στην αρχική',
                    style: GoogleFonts.adventPro(
                      fontSize: 20,
                      color: Colors.red[400].withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
