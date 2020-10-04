import 'package:blue_waves_flutter/models/BeachModel.dart';
import 'package:blue_waves_flutter/models/MemberModel.dart';
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
          child: FlatButton(
            onPressed: () {
              getBeaches();
            },
            child: const Text(
              'GET ALL BEACHES',
            ),
          ),
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
        Positioned(
          bottom: 100,
          left: 120,
          child: FlatButton(
            onPressed: () {
              var beach = const Beach(
                name: 'fff',
                description: 'ffff!!',
                latitude: 20,
                longitute: 40,
              );

              addBeach(beach);
            },
            child: const Text(
              'ADD BEACH',
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
                fontSize: 45,
              ),
            ),
          ),
        )
      ],
    );
  }
}
