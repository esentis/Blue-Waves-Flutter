import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/pages/components/loader.dart';
import 'package:blue_waves/pages/register_login_page/components/login_container.dart';
import 'package:blue_waves/pages/register_login_page/components/register_container.dart';
import 'package:blue_waves/states/loading_state.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import '../components/animated_background/animated_background.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool signin = true;
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
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 700),
              child: signin
                  ? Login(
                      emailController: emailController,
                      passwordController: passwordController,
                      loadingState: loadingState,
                      auth: auth,
                      onRegisterTap: () {
                        setState(() {
                          signin = !signin;
                        });
                      },
                    )
                  : Register(
                      usernameController: usernameController,
                      emailController: emailController,
                      passwordController: passwordController,
                      loadingState: loadingState,
                      onLoginTap: () {
                        setState(() {
                          signin = !signin;
                        });
                      },
                    ),
            ),

            Positioned(
              bottom: 45.h,
              left: 50.w,
              right: 50.w,
              child: TextButton(
                onPressed: Get.back,
                child: Text(
                  S.current.back,
                  style: kStyleDefaultBold.copyWith(
                    fontSize: 18.sp,
                    color: kColorWhite.withOpacity(0.8),
                  ),
                ),
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