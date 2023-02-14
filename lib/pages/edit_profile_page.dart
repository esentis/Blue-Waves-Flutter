import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/pages/components/animated_background/animated_background.dart';
import 'package:blue_waves/pages/components/loader.dart';
import 'package:blue_waves/pages/components/snack_bar.dart';
import 'package:blue_waves/pages/globe_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late PackageInfo packageInfo;
  bool isLoading = true;
  Future<void> getVersion() async {
    packageInfo = await PackageInfo.fromPlatform();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getVersion();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            const AnimatedBackground(
              showTitle: false,
            ),
            if (isLoading)
              const Loader()
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 5,
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 6.1,
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: GestureDetector(
                            onTap: () {
                              showSnack(
                                title: S.current.pointsQuestion,
                                duration: 2300,
                                message: S.current.pointsExplain,
                                firstColor: Colors.blueAccent.withOpacity(0.8),
                                secondColor: Colors.blue.withOpacity(0.7),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      S.current.points,
                                      style: kStyleDefault.copyWith(
                                        color: Colors.orange[50],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Coming soon',
                                      style: kStyleDefaultBold.copyWith(
                                        fontSize: 25.sp,
                                        color: Colors.orange[50],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        await Get.offAll(() => GlobeView());
                      },
                      child: Text(
                        S.current.logout,
                        style: kStyleDefaultBold.copyWith(
                          fontSize: 25.sp,
                          color: Colors.orange[50]!.withOpacity(0.8),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Get.defaultDialog(
                          title: S.current.confirm,
                          backgroundColor: Colors.orange[50],
                          middleText: S.current.deleteExplain,
                          middleTextStyle: kStyleDefault.copyWith(
                            color: Colors.black.withOpacity(0.8),
                          ),
                          titleStyle: kStyleDefault.copyWith(
                            fontSize: 30.sp,
                            color: Colors.red.withOpacity(0.8),
                          ),
                          cancel: GestureDetector(
                            onTap: Get.back,
                            child: Text(
                              S.current.cancel,
                              style: kStyleDefault.copyWith(
                                color: Colors.red.withOpacity(0.8),
                              ),
                            ),
                          ),
                          confirm: GestureDetector(
                            onTap: () async {},
                            child: Text(
                              S.current.delete,
                              style: kStyleDefaultBold.copyWith(
                                color: Colors.red.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        S.current.deleteAccount,
                        style: kStyleDefaultBold.copyWith(
                          fontSize: 25.sp,
                          color: Colors.red.withOpacity(0.8),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'esentakos@yahoo.gr',
                          queryParameters: {'subject': S.current.reportText},
                        );
                        if (await canLaunchUrl(emailLaunchUri)) {
                          await launchUrl(emailLaunchUri);
                        } else {
                          throw 'Could not launch $emailLaunchUri';
                        }
                      },
                      child: Text(
                        S.current.report,
                        style: kStyleDefault.copyWith(
                          fontSize: 14.sp,
                          color: Colors.orange[50],
                        ),
                      ),
                    ),
                    Text(
                      '${S.current.version} ${packageInfo.version}',
                      style: kStyleDefault.copyWith(
                        fontSize: 14.sp,
                        color: Colors.orange[50],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
