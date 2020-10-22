import 'package:animate_do/animate_do.dart';
import 'package:blue_waves_flutter/pages/components/loader.dart';
import 'package:blue_waves_flutter/pages/register_page/components/blue_waves_textfield.dart';
import 'package:blue_waves_flutter/states/loading_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';

import 'package:provider/provider.dart';

import '../connection.dart';
import 'components/animated_background/animated_background.dart';

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
                    loadingState.toggleLoading();
                    try {
                      // await auth.signInWithEmailAndPassword(
                      //     email: emailController.text,
                      //     password: passwordController.text);
                      await auth.signInWithEmailAndPassword(
                          email: 'esentakos@yahoo.gr', password: 'lammerz88!!');
                      loadingState.toggleLoading();
                      await Get.to(HomePage());
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
          loadingState.isLoading ? const Loader() : const SizedBox(),
        ]),
      ),
    );
  }
}
