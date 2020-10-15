import 'package:blue_waves_flutter/controllers/beach_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blue_waves_flutter/connection.dart';

import 'beach_page.dart';
import 'components/animated_background/animated_background.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((User user) {
      if (user == null) {
        logger.w('User is currently signed out');
      } else {
        logger.w('User is signed in');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () async {
            var beaches = await getBeaches();
            logger.i(beaches[0]['name']);
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BeachPage(
                          beach: beaches[2],
                        )));
          },
          child: const Icon(
            Icons.description_outlined,
            size: 50,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Stack(
          children: [
            const AnimatedBackground(),
          ],
        ),
      ),
    );
  }
}
