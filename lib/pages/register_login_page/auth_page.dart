import 'package:animate_do/animate_do.dart';
import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/pages/components/animated_background/animated_background.dart';
import 'package:blue_waves/pages/components/animated_background/waves.dart';
import 'package:blue_waves/pages/components/loader.dart';
import 'package:blue_waves/pages/register_login_page/components/login_container.dart';
import 'package:blue_waves/states/loading_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool registering = false;
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final loadingState = context.watch<LoadingState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FadeIn(
        duration: const Duration(milliseconds: 700),
        child: Stack(
          children: [
            const AnimatedBackground(
              showTitle: true,
              waveHeight: WaveHeight.small,
            ),
            Login(
              usernameController: usernameController,
              emailController: emailController,
              passwordController: passwordController,
              loadingState: loadingState,
              auth: auth,
              registering: registering,
              onRegisterTap: () {
                setState(
                  () {
                    registering = !registering;
                  },
                );
              },
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
          ],
        ),
      ),
    );
  }
}
