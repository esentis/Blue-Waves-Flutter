import 'package:blue_waves/api/api_service.dart';
import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/pages/components/loader.dart';
import 'package:blue_waves/pages/components/snack_bar.dart';
import 'package:blue_waves/states/loading_state.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10.h,
                ),
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
                    style: kStyleDefault.copyWith(
                      fontSize: 25.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                        child: Container(
                          height: 1.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      S.current.or,
                      style: kStyleDefault,
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                        child: Container(
                          height: 1.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                GestureDetector(
                  onTap: () async {
                    UserCredential? user;
                    try {
                      user = await googleSign();
                      log.wtf(user);
                      if (user != null) {
                        final isRegistered =
                            await Api.instance.checkUser(user.user!.uid);
                        if (!isRegistered) {
                          log.i('Google user not registered.');
                          await Api.instance.registerGoogleUser(
                              id: user.user!.uid,
                              displayName: user.user!.email!);
                        }
                      }
                    } catch (e) {
                      log.e(e);
                    }
                  },
                  child: Image.asset(
                    'assets/images/gsign.png',
                    height: 50.h,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextButton(
                  onPressed: Get.back,
                  child: Text(
                    S.current.back,
                    style: kStyleDefaultBold.copyWith(
                      color: Colors.red[400]!.withOpacity(0.8),
                    ),
                  ),
                )
              ],
            ),
            // ignore: prefer_if_elements_to_conditional_expressions
            loadingState.isLoading! ? const Loader() : const SizedBox(),
          ]),
        ),
      ),
    );
  }
}
