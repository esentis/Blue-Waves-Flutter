import 'package:blue_waves_flutter/pages/beaches_stream.dart';
import 'package:blue_waves_flutter/states/loading_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blue_waves_flutter/connection.dart';
import 'components/animated_background/animated_background.dart';
import 'components/loader.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
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
    var loader = context.watch<LoadingState>();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const AnimatedBackground(),
            AllBeaches(),
            loader.isLoading ? const Loader() : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
