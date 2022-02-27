import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/pages/globe_view.dart';
import 'package:blue_waves/pages/register_login_page/auth_page.dart';
import 'package:blue_waves/states/app_config.dart';
import 'package:blue_waves/states/loading_state.dart';
import 'package:blue_waves/states/theme_state.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Supabase.initialize(
    url: 'https://xalypheaznoombgcgysf.supabase.co',
    anonKey: AppConfig.instance.getSupabaseKey(),
    // authCallbackUrlHostname: 'login-callback', // optional
    debug: true // optional
    ,
  );

  AppConfig.instance.versionInformation = await PackageInfo.fromPlatform();
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 10),
    ),
  );
  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }
  await remoteConfig.fetchAndActivate();

  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId(AppConfig.instance.getOneSignalId());

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification
    event.complete(event.notification);
    log.wtf(event);
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
    log.wtf(result.action?.actionId);
    log.wtf(result.notification.title);
    log.wtf(result.notification.additionalData);
    log.wtf(result.notification.body);
    if (result.notification.title == 'test') {
      Get.to(() => AuthPage());
    }
    // Will be called whenever a notification is opened/button pressed.
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    // Will be called whenever the permission changes
    // (ie. user taps Allow on the permission prompt in iOS)
  });

  OneSignal.shared
      .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    // Will be called whenever the subscription changes
    // (ie. user gets registered with OneSignal and gets a user ID)
  });

  OneSignal.shared.setEmailSubscriptionObserver(
      (OSEmailSubscriptionStateChanges emailChanges) {
    // Will be called whenever then user's email subscription changes
    // (ie. OneSignal.setEmail(email) is called and the user gets registered
  });
// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then(
    (accepted) {
      log.wtf("Accepted permission: $accepted");
    },
  );
  runApp(
    MyApp(),
  );
  if (!kDebugMode) {
    await SentryFlutter.init(
      (options) {
        options.dsn = AppConfig.instance.getSentryDsn();
      },
      appRunner: () => runApp(
        MyApp(),
      ),
    );
  }
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
    final analytics = FirebaseAnalytics.instance;

    return ScreenUtilInit(
      builder: () => MultiProvider(
        providers: [
          ListenableProvider<LoadingState>(
            create: (_) => LoadingState(
              isLoading: true,
            ),
          ),
          ListenableProvider<ThemeState>(
            create: (_) => ThemeState(isDark: false),
          ),
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
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/',
          getPages: [
            GetPage(
              name: '/',
              page: () => GlobeView(),
            ),
          ],
          builder: (context, widget) {
            ScreenUtil.setContext(context);
            return MediaQuery(
              //Setting font does not change with system font size
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget ?? const SizedBox(),
            );
          },
        ),
      ),
    );
  }
}
