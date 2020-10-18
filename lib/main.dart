import 'package:blue_waves_flutter/pages/beach_page.dart';
import 'package:blue_waves_flutter/pages/home_page.dart';
import 'package:blue_waves_flutter/states/loading_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var analytics = FirebaseAnalytics();
    // 100 mb max cache memory.
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    return MultiProvider(
      providers: [
        ListenableProvider<LoadingState>(
          create: (_) => LoadingState(
            isLoading: false,
          ),
        )
      ],
      child: MaterialApp(
        title: 'Blue Waves',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        routes: {
          '/': (context) => HomePage(),
          '/beach': (context) => const BeachPage()
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
      ),
    );
  }
}
