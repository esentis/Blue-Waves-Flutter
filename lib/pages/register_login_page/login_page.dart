import 'package:Blue_Waves/pages/components/loader.dart';
import 'package:Blue_Waves/states/loading_state.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import '../../connection.dart';
import '../components/animated_background/animated_background.dart';
import 'components/blue_waves_textfield.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var loadingState = context.watch<LoadingState>();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: FadeIn(
        duration: const Duration(milliseconds: 700),
        child: Stack(children: [
          const AnimatedBackground(
            showTitle: true,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BWTextField(
                  emailController: emailController,
                  labelText: 'Email',
                  type: TextInputType.emailAddress,
                ),
                BWTextField(
                  emailController: passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
                TextButton(
                  onPressed: () async {
                    loadingState.toggleLoading();

                    try {
                      await auth.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);

                      loadingState.toggleLoading();
                      await Get.offAllNamed('/home');
                    } catch (e) {
                      loadingState.toggleLoading();
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
                    Get.back();
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
          loadingState.isLoading ? const Loader() : const SizedBox(),
        ]),
      ),
    );
  }
}
