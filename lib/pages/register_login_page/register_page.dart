import 'package:animate_do/animate_do.dart';
import 'package:blue_waves/api/api_service.dart';
import 'package:blue_waves/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/models/member.dart';
import 'package:blue_waves/pages/components/loader.dart';
import 'package:blue_waves/pages/components/snack_bar.dart';
import 'package:blue_waves/states/loading_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:string_extensions/string_extensions.dart';

import '../components/animated_background/animated_background.dart';
import 'components/password_field.dart';
import 'components/text_field.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                    emailController: usernameController,
                    labelText: S.current.username,
                  ),
                  BWTextField(
                    emailController: emailController,
                    type: TextInputType.emailAddress,
                    labelText: 'Email',
                  ),
                  BWPasswordField(
                    emailController: passwordController,
                    labelText: S.current.pass,
                  ),
                  TextButton(
                    onPressed: () async {
                      loadingState.toggleLoading();
                      if (!emailController.text.isMail()) {
                        loadingState.toggleLoading();
                        log.wtf('im here ${emailController.text}');

                        return showSnack(
                          title: S.current.error,
                          message: S.current.errorMail,
                          firstColor: Colors.red,
                          secondColor: Colors.red[800]!,
                          duration: 2800,
                        );
                      }
                      try {
                        await Api.instance.registerUser(
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
                      S.current.register,
                      style: kStyleDefaultBold.copyWith(
                        fontSize: 25.sp,
                        color: Colors.orange[50]!.withOpacity(0.8),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.current.back,
                      style: kStyleDefaultBold.copyWith(
                        color: Colors.red[400]!.withOpacity(0.8),
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
