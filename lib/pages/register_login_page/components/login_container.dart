import 'package:blue_waves/api/api_service.dart';
import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/models/member.dart';
import 'package:blue_waves/pages/components/snack_bar.dart';
import 'package:blue_waves/pages/home_page.dart';
import 'package:blue_waves/pages/register_login_page/components/text_field.dart';
import 'package:blue_waves/states/loading_state.dart';
import 'package:blue_waves/states/theme_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:string_extensions/string_extensions.dart';

class Login extends StatelessWidget {
  const Login({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.usernameController,
    required this.loadingState,
    required this.auth,
    required this.onRegisterTap,
    this.registering = false,
  }) : super(key: key);
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final LoadingState loadingState;
  final FirebaseAuth auth;
  final VoidCallback onRegisterTap;
  final bool registering;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 10.h,
        ),
        if (registering)
          BWTextField(
            controller: usernameController,
            obscureText: false,
            labelText: S.current.username,
          ),
        BWTextField(
          controller: emailController,
          obscureText: false,
          labelText: 'Email',
          type: TextInputType.emailAddress,
        ),
        BWTextField(
          controller: passwordController,
          type: TextInputType.emailAddress,
          labelText: S.current.pass,
          isPassword: true,
        ),
        SizedBox(
          height: 20.h,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              ThemeState.of(context, listen: true).isDark
                  ? kColorBlue
                  : kColorOrangeLight,
            ),
          ),
          onPressed: registering
              ? () async {
                  loadingState.toggleLoading();
                  if (!emailController.text.isMail()!) {
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
                    await Get.offAll(() => HomePage());
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
                }
              : () async {
                  loadingState.toggleLoading();

                  try {
                    await auth.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text);

                    loadingState.toggleLoading();
                    await Get.offAll(() => HomePage());
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
            registering ? S.current.register : S.current.login,
            style: kStyleDefaultBold.copyWith(
              fontSize: 24.sp,
              color: ThemeState.of(context, listen: true).isDark
                  ? kColorOrangeLight
                  : kColorBlue,
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        GestureDetector(
          onTap: onRegisterTap,
          child: Text(
            registering ? S.current.login : S.current.register,
            style: kStyleDefault.copyWith(
              fontSize: 17.sp,
              color: ThemeState.of(context, listen: true).isDark
                  ? kColorOrangeLight!.withOpacity(0.6)
                  : kColorWhite,
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
                  height: 0.3.h,
                  color: kColorWhite,
                ),
              ),
            ),
            Text(
              S.current.or,
              style: kStyleDefault.copyWith(
                fontSize: 17.sp,
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: Container(
                  height: 0.3.h,
                  color: kColorWhite,
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
                      id: user.user!.uid, displayName: user.user!.email!);
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
      ],
    );
  }
}
