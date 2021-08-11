import 'package:blue_waves/api/api_service.dart';
import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/models/member.dart';
import 'package:blue_waves/pages/components/snack_bar.dart';
import 'package:blue_waves/pages/register_login_page/components/password_field.dart';
import 'package:blue_waves/pages/register_login_page/components/text_field.dart';
import 'package:blue_waves/states/loading_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:string_extensions/string_extensions.dart';

class Register extends StatelessWidget {
  const Register({
    Key? key,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.loadingState,
    required this.onLoginTap,
  }) : super(key: key);

  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final LoadingState loadingState;
  final VoidCallback onLoginTap;
  @override
  Widget build(BuildContext context) {
    return Column(
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
            style: kStyleDefault.copyWith(
              fontSize: 22.sp,
              color: kColorOrangeLight!.withOpacity(0.8),
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
          onTap: onLoginTap,
          child: Text(
            S.current.login,
            style: kStyleDefault.copyWith(
              fontSize: 18.sp,
              color: kColorOrangeLight2,
            ),
          ),
        ),
      ],
    );
  }
}
