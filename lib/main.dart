import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/pages/beach_page/beach_page.dart';
import 'package:blue_waves/pages/landing_page.dart';
import 'package:blue_waves/pages/register_login_page/login_page.dart';
import 'package:blue_waves/pages/register_login_page/register_page.dart';
import 'package:blue_waves/states/loading_state.dart';
import 'package:blue_waves/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN'];
    },
    appRunner: () => runApp(
      MyApp(),
    ),
  );
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
    final analytics = FirebaseAnalytics();
    // 100 mb max cache memory.
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    return ScreenUtilInit(
      builder: () => MultiProvider(
        providers: [
          ListenableProvider<LoadingState>(
            create: (_) => LoadingState(
              isLoading: false,
            ),
          )
        ],
        child: GetMaterialApp(
          title: 'Blue Waves',
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
            SentryNavigatorObserver(),
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
      ),
    );
  }
}
