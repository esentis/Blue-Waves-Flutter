import 'package:Blue_Waves/controllers/beach_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'beach_page/beach_page.dart';
import 'components/animated_background/animated_background.dart';

class RatedBeaches extends StatelessWidget {
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
          'Βαθμολογημένες παραλίες',
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
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('ratings')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return ListTile(
                        onTap: () async {
                          var beach =
                              await getBeach(document.data()['beachId']);

                          await Get.to(
                            BeachPage(
                              beach: beach,
                            ),
                          );
                        },
                        title: Text(
                          document.data()['beachName'],
                          style: GoogleFonts.adventPro(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[50],
                          ),
                        ),
                        subtitle: Text(
                          document.data()['date'],
                          style: GoogleFonts.adventPro(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[50],
                          ),
                        ),
                        trailing: Text(
                          document.data()['rating'].toString(),
                          style: GoogleFonts.adventPro(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[50],
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
