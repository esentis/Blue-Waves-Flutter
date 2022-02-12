import 'package:blue_waves/constants.dart';
import 'package:blue_waves/models/beach.dart';
import 'package:blue_waves/models/favorite.dart';
import 'package:blue_waves/models/member.dart';
import 'package:blue_waves/models/photo.dart';
import 'package:blue_waves/models/rating.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Api {
  factory Api() {
    return instance;
  }
  static final Api instance = Api._internal();
  Api._internal();

  /// Returns all beaches.
  Future<List<Beach>> getAllBeaches() async {
    PostgrestResponse<dynamic> response;
    try {
      response =
          await Supabase.instance.client.from('beaches').select().execute();

      if (response.data == null || response.data.isEmpty) {
        return [];
      }
      return List<Beach>.generate(
        response.data.length,
        (index) => Beach.fromMap(response.data[index]),
      );
    } on DioError catch (e) {
      log.e(e.message);
      return <Beach>[];
    }
  }

  /// Returns a beach with the provided [id].
  Future<Beach?> getBeach({required String id}) async {
    PostgrestResponse<dynamic> response;
    try {
      response = await Supabase.instance.client
          .from('beaches')
          .select()
          .eq('id', id)
          .execute();

      return Beach.fromMap(response.data['results']);
    } on DioError catch (e) {
      log.e(e.message);
      return null;
    }
  }

  /// Registers the user in Firebase so as to Supabase.
  Future<String> registerUser(Member user) async {
    final userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: user.email!,
      password: user.password!,
    );
    PostgrestResponse<dynamic> response;
    try {
      response = await Supabase.instance.client.from('members').insert({
        'externalId': userCredential.user!.uid,
        'username': user.displayName,
        'email': user.email,
      }).execute();
      return response.data['createdAt'];
    } on DioError catch (e) {
      log.e(e.message);
      return e.message;
    }
  }

  /// Starts Google Auth registration.
  Future<String> registerGoogleUser({
    required String id,
    required String displayName,
  }) async {
    PostgrestResponse<dynamic> response;
    try {
      response = await Supabase.instance.client.from('members').insert({
        'externalId': id,
        'username': displayName,
        'email': displayName,
      }).execute();

      log.wtf(response.data);
      return 'ok';
    } on DioError catch (e) {
      log.e(e.message);
      return e.message;
    }
  }

  /// Check if the user is already registered.
  Future<bool> checkUser(String email) async {
    PostgrestResponse<dynamic> response;
    try {
      response = await Supabase.instance.client
          .from('members')
          .select()
          .eq('email', email)
          .execute();

      if (response.data == null || response.data.isEmpty) {
        return false;
      }
      return true;
    } on DioError catch (e) {
      log.e(e.message);
      return false;
    }
  }

  /// Checks whether the user with [email] has already rated
  Future<bool> checkRating(String email, int beachId) async {
    PostgrestResponse<dynamic> response;
    try {
      response = await Supabase.instance.client
          .from('ratings')
          .select()
          .eq('member', email)
          .eq('beach', beachId)
          .execute();

      if (response.data == null || response.data.isEmpty) {
        return true;
      }
      return false;
    } on DioError catch (e) {
      log.e(e.message);
      return true;
    }
  }

  /// Adds a new rating for the Beach.
  ///
  /// [Rating] has required [beach] id, [rating] & [userMail].
  Future<String> addRating(Rating rating) async {
    PostgrestResponse<dynamic> response;
    if (await checkRating(rating.userMail, rating.beachId)) {
      try {
        response = await Supabase.instance.client.from('ratings').insert({
          'beach': rating.beachId,
          'member': rating.userMail,
          'rating': rating.rating,
          'review': rating.review,
        }).execute();
        log.wtf(response.data);
        return response.data.first['created_at'];
      } on DioError catch (e) {
        log.e(e.message);
        return e.message;
      }
    }
    log.wtf('User has already rated this beach');
    return '';
  }

  /// Checks whether the user with [email] has already the beach with ID [beachId]
  ///
  /// at his favorites list.
  Future<bool> checkFavorite(String email, int beachId) async {
    PostgrestResponse<dynamic> response;
    try {
      response = await Supabase.instance.client
          .from('favorites')
          .select()
          .eq('member', email)
          .eq('beach', beachId)
          .execute();

      if (response.data == null || response.data.isEmpty) {
        return true;
      }
      return false;
    } on DioError catch (e) {
      log.e(e.message);
      return true;
    }
  }

  /// Adds a beach in favorites list.
  ///
  /// [Favorite] has required [beach] id & [userMail].
  Future<String> addFavorite(Favorite favorite) async {
    PostgrestResponse<dynamic> response;
    if (await checkFavorite(favorite.userMail, favorite.beachId)) {
      try {
        response = await Supabase.instance.client.from('favorites').insert({
          'beach': favorite.beachId,
          'member': favorite.userMail,
        }).execute();
        log.wtf(response.data);
        return response.data.first['created_at'];
      } on DioError catch (e) {
        log.e(e.message);
        return e.message;
      }
    }
    log.wtf('User has already favorited this beach');
    return '';
  }

  /// Returns all the images associated with a beach with ID [id]
  ///
  /// If there are no results an empty `List` is returned.
  Future<List<Photo>> getImages(int id) async {
    PostgrestResponse<dynamic> response;

    try {
      response = await Supabase.instance.client
          .from('images')
          .select()
          .eq('beach', id)
          .execute();

      log.wtf(response.data);
      if (response.data == null || response.data.isEmpty) {
        return [];
      }
      return List<Photo>.generate(
        response.data.length,
        (index) => Photo.fromJson(
          response.data[index],
        ),
      );
    } on DioError catch (e) {
      log.e(e.message);
      return [];
    }
  }
}
