import 'package:blue_waves_flutter/controllers/beach_controller.dart';
import 'package:blue_waves_flutter/models/Beach.dart';
import 'package:blue_waves_flutter/models/Member.dart';
import 'package:blue_waves_flutter/pages/components/title.dart';
import 'package:blue_waves_flutter/pages/components/tropical_island.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blue_waves_flutter/connection.dart';

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
        Positioned(
          bottom: 0,
          left: 200,
          child: FlatButton(
            onPressed: () async {
              var newMember = Member(
                email: '1@1.gr',
                password: 'Dummy1!!',
                displayName: 'Macho man',
                photoUrl: 'www.google.com',
              );
              await registerMember(newMember);
            },
            child: const Text(
              'REGISTER MEMBER',
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 120,
          child: FlatButton(
            onPressed: () {
              var lgnMember = Member(
                email: '1@1.gr',
                password: 'Dummy1!!',
              );
              signInMember(lgnMember);
            },
            child: const Text(
              'LOGIN MEMBER',
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              signOutMember();
            },
            child: const Text(
              'Sign out',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              addBeach(
                const Beach(
                  description: 'Thisss comes from flutter',
                  name: 'esentis',
                  latitude: 40.5,
                  longitude: 24.5,
                ),
              );
            },
            child: const Text(
              'Add Beach',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              getBeaches();
            },
            child: const Text(
              'Get Beaches',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
