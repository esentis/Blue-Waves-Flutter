import 'package:Blue_Waves/connection.dart';
import 'package:Blue_Waves/pages/components/animated_background/animated_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Blue_Waves/controllers/beach_controller.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/loader.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  PackageInfo packageInfo;
  bool isLoading = true;
  Future getVersion() async {
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
        backgroundColor: Colors.orange[50].withOpacity(0.8),
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
          isLoading
              ? const Loader()
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                                onTap: () {
                                  Get.back();
                                },
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
                                    await users
                                        .where('id',
                                            isEqualTo: FirebaseAuth
                                                .instance.currentUser.uid)
                                        .get()
                                        .then((value) async {
                                      await users
                                          .doc(value.docs.first.data()['docId'])
                                          .delete();
                                    });
                                    await FirebaseAuth.instance.currentUser
                                        .delete();
                                    await Get.offAllNamed('/');
                                  } catch (e) {
                                    logger.e(e);
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
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          var _emailLaunchUri = Uri(
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
                        'Έκδοση ${packageInfo.version ?? ''}',
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
