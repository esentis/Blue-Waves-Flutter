// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Ratings`
  String get pageBeachRatings {
    return Intl.message(
      'Ratings',
      name: 'pageBeachRatings',
      desc: '',
      args: [],
    );
  }

  /// `Rating`
  String get pageBeachRating {
    return Intl.message(
      'Rating',
      name: 'pageBeachRating',
      desc: '',
      args: [],
    );
  }

  /// `You have already rated : `
  String get pageBeachRated {
    return Intl.message(
      'You have already rated : ',
      name: 'pageBeachRated',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get login {
    return Intl.message(
      'Sign in',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get logout {
    return Intl.message(
      'Sign out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get deleteAccount {
    return Intl.message(
      'Delete account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Delete your account permanently, there is no retrieve option.`
  String get deleteExplain {
    return Intl.message(
      'Delete your account permanently, there is no retrieve option.',
      name: 'deleteExplain',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get report {
    return Intl.message(
      'Report',
      name: 'report',
      desc: '',
      args: [],
    );
  }

  /// `Report a problem/issue.`
  String get reportText {
    return Intl.message(
      'Report a problem/issue.',
      name: 'reportText',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get pass {
    return Intl.message(
      'Password',
      name: 'pass',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Or`
  String get or {
    return Intl.message(
      'Or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong, try again later !`
  String get errorText {
    return Intl.message(
      'Something went wrong, try again later !',
      name: 'errorText',
      desc: '',
      args: [],
    );
  }

  /// `Your email is not correct`
  String get errorMail {
    return Intl.message(
      'Your email is not correct',
      name: 'errorMail',
      desc: '',
      args: [],
    );
  }

  /// `Back to home`
  String get back {
    return Intl.message(
      'Back to home',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Points`
  String get points {
    return Intl.message(
      'Points',
      name: 'points',
      desc: '',
      args: [],
    );
  }

  /// `What are points ?`
  String get pointsQuestion {
    return Intl.message(
      'What are points ?',
      name: 'pointsQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Everytime you contribute in any way, either by rating or adding beach information, you gain Karma points.`
  String get pointsExplain {
    return Intl.message(
      'Everytime you contribute in any way, either by rating or adding beach information, you gain Karma points.',
      name: 'pointsExplain',
      desc: '',
      args: [],
    );
  }

  /// `Favorite beaches`
  String get favoritedBeaches {
    return Intl.message(
      'Favorite beaches',
      name: 'favoritedBeaches',
      desc: '',
      args: [],
    );
  }

  /// `Rated beaches`
  String get ratedBeaches {
    return Intl.message(
      'Rated beaches',
      name: 'ratedBeaches',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get editProfile {
    return Intl.message(
      'Edit profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `No internet active internet connection found`
  String get noConnection {
    return Intl.message(
      'No internet active internet connection found',
      name: 'noConnection',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `You're currently not logged`
  String get notLogged {
    return Intl.message(
      'You\'re currently not logged',
      name: 'notLogged',
      desc: '',
      args: [],
    );
  }

  /// `No description found for the beach`
  String get noDescription {
    return Intl.message(
      'No description found for the beach',
      name: 'noDescription',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to contribute ?`
  String get contribute {
    return Intl.message(
      'Do you want to contribute ?',
      name: 'contribute',
      desc: '',
      args: [],
    );
  }

  /// `Logged in as`
  String get logged_as {
    return Intl.message(
      'Logged in as',
      name: 'logged_as',
      desc: '',
      args: [],
    );
  }

  /// `source`
  String get source {
    return Intl.message(
      'source',
      name: 'source',
      desc: '',
      args: [],
    );
  }

  /// `New features coming soon...`
  String get coming_soon {
    return Intl.message(
      'New features coming soon...',
      name: 'coming_soon',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'el'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
