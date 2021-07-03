import 'package:Blue_Waves/constants.dart';
import 'package:Blue_Waves/controllers/user_controller.dart';
import 'package:Blue_Waves/models/Member.dart';
import 'package:Blue_Waves/pages/components/loader.dart';
import 'package:Blue_Waves/pages/components/snack_bar.dart';
import 'package:Blue_Waves/states/loading_state.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/animated_background/animated_background.dart';
import 'package:string_extensions/string_extensions.dart';

import 'package:provider/provider.dart';

import 'components/password_field.dart';
import 'components/text_field.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var loadingState = context.watch<LoadingState>();
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
                    emailController: usernameController,
                    labelText: 'Όνομα χρήστη',
                  ),
                  BWTextField(
                    emailController: emailController,
                    type: TextInputType.emailAddress,
                    labelText: 'Email',
                  ),
                  BWPasswordField(
                    emailController: passwordController,
                    labelText: 'Κωδικός',
                  ),
                  TextButton(
                    onPressed: () async {
                      loadingState.toggleLoading();
                      if (!emailController.text.isMail()) {
                        loadingState.toggleLoading();
                        log.wtf('im here ${emailController.text}');

                        return showSnack(
                          title: 'Κάτι πήγε στραβά',
                          message: 'Το email που δώσατε δεν είναι σωστό',
                          firstColor: Colors.red,
                          secondColor: Colors.red[800]!,
                          duration: 2800,
                        );
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
                      } on FirebaseAuthException catch (e) {
                        loadingState.toggleLoading();
                        showSnack(
                          title: 'Κάτι πήγε στραβά',
                          message: e.message,
                          firstColor: Colors.red,
                          secondColor: Colors.red[800]!,
                          duration: 2800,
                        );
                        log.e(e);
                      }
                    },
                    child: Text(
                      'Εγγραφή',
                      style: GoogleFonts.adventPro(
                        fontSize: 25,
                        color: Colors.orange[50]!.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Επιστροφή στην αρχική',
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
            loadingState.isLoading! ? const Loader() : const SizedBox(),
          ]),
        ),
      ),
    );
  }
}
