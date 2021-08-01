import 'package:blue_waves/constants.dart';
import 'package:blue_waves/pages/edit_profile_page.dart';
import 'package:blue_waves/pages/favorites_page.dart';
import 'package:blue_waves/pages/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlueWavesTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        await FirebaseAuth.instance.signOut();
        await Get.offAll(() => LandingPage());
      },
      onLongPress: () async {
        await Get.to(() => EditProfilePage());
      },
      child: RichText(
        text: TextSpan(
          text: 'Blue ',
          style: kStyleDefaultBold.copyWith(
            fontSize: 45.sp,
            color: const Color(0xff005295),
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Waves',
              style: kStyleDefaultBold.copyWith(
                fontSize: 45.sp,
                color: const Color(0xff18A6EC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
