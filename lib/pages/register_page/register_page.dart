import 'package:animate_do/animate_do.dart';
import 'package:blue_waves_flutter/controllers/beach_controller.dart';
import 'package:blue_waves_flutter/models/Member.dart';
import 'package:blue_waves_flutter/pages/components/loader.dart';
import 'package:blue_waves_flutter/states/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../connection.dart';
import '../components/animated_background/animated_background.dart';
import 'package:string_extensions/string_extensions.dart';

import 'package:provider/provider.dart';

import 'components/blue_waves_textfield.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var loadingState = context.watch<LoadingState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var usernameController = TextEditingController();

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
                  emailController: usernameController,
                  labelText: 'Username',
                ),
                BWTextField(
                  emailController: emailController,
                  labelText: 'Email',
                ),
                BWTextField(
                  emailController: passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
                FlatButton(
                  onPressed: () async {
                    loadingState.toggleLoading();
                    if (!emailController.text.isMail()) {
                      return logger.i('Email is not valid');
                    }
                    try {
                      await registerUser(
                        Member(
                          displayName: usernameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        ),
                      );
                      loadingState.toggleLoading();
                      await Get.offAllNamed('/home');
                    } catch (e) {
                      loadingState.toggleLoading();
                      logger.e(e);
                    }
                  },
                  child: Text(
                    'Εγγραφή',
                    style: GoogleFonts.adventPro(
                      fontSize: 25,
                      color: Colors.orange[50].withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
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
