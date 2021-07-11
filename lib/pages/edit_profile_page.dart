import 'package:blue_waves/constants.dart';
import 'package:blue_waves/controllers/user_controller.dart';
import 'package:blue_waves/pages/components/animated_background/animated_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/loader.dart';
import 'components/snack_bar.dart';
import 'landing_page.dart';

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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getVersion();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.blue,
            size: 40,
          ),
        ),
        backgroundColor: Colors.orange[50]!.withOpacity(0.8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Επεξεργασία προφίλ',
          style: GoogleFonts.adventPro(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      body: Stack(
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
                          top: MediaQuery.of(context).size.height / 5),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 6.1,
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: StreamBuilder(
                          stream: usersRef.get().asStream(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              return GestureDetector(
                                onTap: () {
                                  showSnack(
                                    title: 'Τι είναι οι πόντοι;',
                                    duration: 2300,
                                    message:
                                        'Κάθε φορά που βαθμολογείς μια παραλία κερδίζεις πόντους !',
                                    firstColor:
                                        Colors.blueAccent.withOpacity(0.8),
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
                                          'Πόντοι',
                                          style: GoogleFonts.adventPro(
                                            fontSize: 20,
                                            color: Colors.orange[50],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          snapshot.data!.toString(),
                                          style: GoogleFonts.adventPro(
                                            fontSize: 25,
                                            color: Colors.orange[50],
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      await Get.to(LandingPage());
                    },
                    child: Text(
                      'Αποσύνδεση',
                      style: GoogleFonts.adventPro(
                        fontSize: 25,
                        color: Colors.orange[50]!.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await Get.defaultDialog(
                          title: 'Επιβεβαίωση',
                          backgroundColor: Colors.orange[50],
                          middleText:
                              'Διαγράψτε το λογαριασμό σας οριστικά. Δε θα έχετε δυνατότητα επαναφοράς',
                          middleTextStyle: GoogleFonts.adventPro(
                            fontSize: 20,
                            color: Colors.black.withOpacity(0.8),
                          ),
                          titleStyle: GoogleFonts.adventPro(
                            fontSize: 30,
                            color: Colors.red.withOpacity(0.8),
                          ),
                          cancel: GestureDetector(
                            onTap: Get.back,
                            child: Text(
                              'Ακύρωση',
                              style: GoogleFonts.adventPro(
                                fontSize: 20,
                                color: Colors.red.withOpacity(0.8),
                              ),
                            ),
                          ),
                          confirm: GestureDetector(
                            onTap: () async {
                              try {
                                await usersRef.once().then((value) {
                                  log.wtf(value);
                                });
                                await FirebaseAuth.instance.currentUser!
                                    .delete();
                                await Get.offAllNamed('/');
                              } catch (e) {
                                log.e(e);
                              }
                            },
                            child: Text(
                              'Διαγραφή',
                              style: GoogleFonts.adventPro(
                                fontSize: 20,
                                color: Colors.red.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ));
                    },
                    child: Text(
                      'Διαγραφή λογαριασμού',
                      style: GoogleFonts.adventPro(
                        fontSize: 25,
                        color: Colors.red.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final _emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'esentakos@yahoo.gr',
                        queryParameters: {
                          'subject': 'Αναφορά προβλήματος/ζητήματος'
                        },
                      );
                      if (await canLaunch(_emailLaunchUri.toString())) {
                        await launch(_emailLaunchUri.toString());
                      } else {
                        throw 'Could not launch $_emailLaunchUri';
                      }
                    },
                    child: Text(
                      'Αναφορά',
                      style: GoogleFonts.adventPro(
                        fontSize: 18,
                        color: Colors.orange[50],
                      ),
                    ),
                  ),
                  Text(
                    'Έκδοση ${packageInfo.version}',
                    style: GoogleFonts.adventPro(
                      fontSize: 20,
                      color: Colors.orange[50],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
