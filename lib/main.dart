import 'package:Blue_Waves/pages/beach_page/beach_page.dart';
import 'package:Blue_Waves/pages/landing_page.dart';
import 'package:Blue_Waves/pages/register_login_page/login_page.dart';
import 'package:Blue_Waves/pages/register_login_page/register_page.dart';
import 'package:Blue_Waves/states/loading_state.dart';
import 'package:Blue_Waves/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';

void main() async {
  await DotEnv().load('.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // LOCK THE ORIENTATION
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
