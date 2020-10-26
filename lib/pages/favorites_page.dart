import 'package:Blue_Waves/pages/beach_page.dart';
import 'package:Blue_Waves/pages/components/animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Blue_Waves/controllers/beach_controller.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedBackground(
            showTitle: false,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
              child: Text(
                'Αγαπημένες παραλίες',
                style: GoogleFonts.adventPro(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[50],
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('favorites')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading');
                  }

                  return ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return TextButton(
                        onPressed: () async {
                          var beach =
                              await getBeach(document.data()['beachId']);
                          await Get.to(
                            BeachPage(
                              beach: beach,
                            ),
                          );
                        },
                        child: Text(
                          document.data()['beachName'],
                          style: GoogleFonts.adventPro(
                            fontSize: 35,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
