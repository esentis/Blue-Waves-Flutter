import 'package:blue_waves_flutter/pages/components/title.dart';
import 'package:blue_waves_flutter/pages/components/tropical_island.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blue_waves_flutter/connection.dart';

import 'components/abyss.dart';
import 'components/birds.dart';
import 'components/sun.dart';
import 'components/waves.dart';

class BlueWaves extends StatefulWidget {
  @override
  _BlueWavesState createState() => _BlueWavesState();
}

class _BlueWavesState extends State<BlueWaves> {
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
    return Stack(
      children: [
        Container(
          color: Colors.orange[50],
        ),
        Positioned(
          left: 50,
          child: Sun(),
        ),
        Positioned(
          top: 0,
          child: Birds(),
        ),
        Positioned(
          child: TropicalIsland(),
        ),
        Positioned(
          child: Waves(),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 13,
          left: MediaQuery.of(context).size.width / 4,
          child: BlueWavesTitle(),
        ),
        const Abyss(),
      ],
    );
  }
}
