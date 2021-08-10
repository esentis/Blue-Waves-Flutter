import 'package:blue_waves/api/api_service.dart';
import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/pages/components/snack_bar.dart';
import 'package:blue_waves/pages/register_login_page/components/password_field.dart';
import 'package:blue_waves/pages/register_login_page/components/text_field.dart';
import 'package:blue_waves/states/loading_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  const Login({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.loadingState,
    required this.auth,
    required this.onRegisterTap,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final LoadingState loadingState;
  final FirebaseAuth auth;
  final VoidCallback onRegisterTap;
  @override
  Widget build(BuildContext context) {
    return Column(
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
              fontSize: 22.sp,
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
                  color: kColorWhite,
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
          onTap: onRegisterTap,
          child: Text(
            S.current.register,
            style: kStyleDefault.copyWith(
              fontSize: 18.sp,
              color: kColorOrangeLight2,
            ),
          ),
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
