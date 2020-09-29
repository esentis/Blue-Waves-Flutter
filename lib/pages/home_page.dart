import 'package:blue_waves_flutter/models/RegisterMemberModel.dart';
import 'package:blue_waves_flutter/pages/components/title.dart';
import 'package:blue_waves_flutter/pages/components/tropical_island.dart';
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
        // Positioned(
        //   left: MediaQuery.of(context).size.width / 4,
        //   top: MediaQuery.of(context).size.height / 10,
        //   bottom: 0,
        //   child: Lottie.network(
        //     'https://assets5.lottiefiles.com/datafiles/EkoZpNsbNMU956i/data.json',
        //     animate: true,
        //     repeat: true,
        //     width: 250,
        //   ),
        // ),
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
            onPressed: () {
              var newMember = RegisterMemberModel(
                userName: 'dummy',
                email: 'dummy@dummy.gr',
                password: 'Dummy1!!',
                confirmPassword: 'Dummy1!!',
              );

              registerMember(newMember);
            },
            child: const Text(
              'REGISTER MEMBER',
            ),
          ),
        ),
      ],
    );
  }
}
