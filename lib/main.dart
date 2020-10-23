import 'package:blue_waves_flutter/pages/beach_page.dart';
import 'package:blue_waves_flutter/pages/home_page.dart';
import 'package:blue_waves_flutter/pages/landing_page.dart';
import 'package:blue_waves_flutter/pages/login_page.dart';
import 'package:blue_waves_flutter/pages/register_page/register_page.dart';
import 'package:blue_waves_flutter/states/loading_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/foundation.dart' show kDebugMode;

void main() async {
  await DotEnv().load('.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // if (kDebugMode) {
  //   // Force disable Crashlytics collection while doing every day development.
  //   // Temporarily toggle this to true if you want to test crash reporting in your app.
  //   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // } else {
  //   // Handle Crashlytics enabled status when not in Debug,
  //   // e.g. allow your users to opt-in to crash reporting.
  // }
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
      child: GetMaterialApp(
        title: 'Blue Waves',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => LandingPage()),
          GetPage(
            name: '/home',
            page: () => HomePage(),
          ),
          GetPage(
            name: '/beach',
            page: () => const BeachPage(),
            transition: Transition.fadeIn,
          ),
          GetPage(
            name: '/register',
            page: () => RegisterPage(),
          ),
          GetPage(
            name: '/login',
            page: () => LoginPage(),
          ),
        ],
      ),
    );
  }
}
