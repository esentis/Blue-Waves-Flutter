import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/pages/components/loader.dart';
import 'package:blue_waves/pages/components/snack_bar.dart';
import 'package:blue_waves/states/loading_state.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import '../components/animated_background/animated_background.dart';
import 'components/password_field.dart';
import 'components/text_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final loadingState = context.watch<LoadingState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: FadeIn(
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
                  BWPasswordField(
                    emailController: passwordController,
                    labelText: S.current.pass,
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
                      } on FirebaseAuthException catch (e) {
                        loadingState.toggleLoading();
                        showSnack(
                          title: S.current.error,
                          message: e.message!,
                          firstColor: Colors.red,
                          secondColor: Colors.red[800]!,
                          duration: 2800,
                        );
                        log.e(e);
                      }
                    },
                    child: Text(
                      S.current.login,
                      style: GoogleFonts.adventPro(
                        fontSize: 35,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: Get.back,
                    child: Text(
                      S.current.back,
                      style: GoogleFonts.adventPro(
                        fontSize: 20,
                        color: Colors.red[400]!.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            // ignore: prefer_if_elements_to_conditional_expressions
            loadingState.isLoading! ? const Loader() : const SizedBox(),
          ]),
        ),
      ),
    );
  }
}
