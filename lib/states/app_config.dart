import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info/package_info.dart';

class AppConfig {
  factory AppConfig() {
    return instance;
  }
  static final AppConfig instance = AppConfig._internal();
  AppConfig._internal();

  RemoteConfig remoteConfig = RemoteConfig.instance;

  PackageInfo? versionInformation;

  PackageInfo? get getVersionInformation => versionInformation;

  String getApiKey() {
    return remoteConfig.getString('api_key');
  }

  String getSentryDsn() {
    return remoteConfig.getString('sentry_dsn');
  }

  String getAdUnitId() {
    return remoteConfig.getString('adunit_id');
  }

  String getAdmobId() {
    return remoteConfig.getString('admob_id');
  }

  String getOneSignalId() {
    return remoteConfig.getString('onesignal_id');
  }
}
