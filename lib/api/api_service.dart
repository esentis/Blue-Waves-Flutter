import 'package:blue_waves/constants.dart';
import 'package:blue_waves/models/Member.dart';
import 'package:blue_waves/models/beach.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Api {
  factory Api() {
    return instance;
  }
  static final Api instance = Api._internal();
  Api._internal();

  Future<List<Beach>> getAllBeaches() async {
    PostgrestResponse<dynamic> response;
    try {
      response = await Supabase.instance.client.from('beaches').execute();
      log.wtf(response.data);
      if (response.data == null) {
        return [];
      }
      return List<Beach>.generate(
        response.data['beaches'].length,
        (index) => Beach.fromMap(response.data['beaches'][index]),
      );
    } on DioError catch (e) {
      log.e(e.message);
      return <Beach>[];
    }
  }

  // Future<Beach?> getBeach({required String id}) async {
  //   Response<dynamic> response;
  //   try {
  //     response = await http.get('beaches/$id');
  //     return Beach.fromMap(response.data['results']);
  //   } on DioError catch (e) {
  //     log.e(e.message);
  //     return null;
  //   }
  // }

  // Future<bool> toggleFavorite({
  //   required String userId,
  //   required String beachId,
  // }) async {
  //   try {
  //     await http.post(
  //       'favorites/',
  //       data: {
  //         'userId': userId,
  //         'beachId': beachId,
  //       },
  //     );
  //     return true;
  //   } on DioError catch (e) {
  //     log.e(e.message);
  //     return false;
  //   }
  // }

  // Future<bool> checkFavorite({
  //   required String userId,
  //   required String beachId,
  // }) async {
  //   Response<dynamic> response;
  //   try {
  //     response = await http.post(
  //       'favorites/check',
  //       data: {
  //         'userId': userId,
  //         'beachId': beachId,
  //       },
  //     );
  //     return response.data['results'];
  //   } on DioError catch (e) {
  //     log.e(e.message);
  //     return false;
  //   }
  // }

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

  Future<bool> checkUser(String email) async {
    PostgrestResponse<dynamic> response;
    try {
      response = await Supabase.instance.client
          .from('members')
          .select()
          .eq('email', email)
          .execute();

      if (response.data == null) {
        return false;
      }
      return true;
    } on DioError catch (e) {
      log.e(e.message);
      return false;
    }
  }

  // Future<String> addRating(Rating rating) async {
  //   Response<dynamic> response;
  //   try {
  //     response = await http.post(
  //       'ratings/',
  //       data: {
  //         'beachId': rating.beachId,
  //         'userId': rating.userUid,
  //         'rating': rating.rating,
  //         'review': rating.review,
  //       },
  //     );
  //     return response.data['createdAt'];
  //   } on DioError catch (e) {
  //     log.e(e.message);
  //     return e.message;
  //   }
  // }
}
