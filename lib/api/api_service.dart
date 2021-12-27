import 'package:blue_waves/constants.dart';
import 'package:blue_waves/models/beach.dart';
import 'package:blue_waves/models/member.dart';
import 'package:blue_waves/models/rating.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class Api {
  factory Api() {
    return instance;
  }
  static final Api instance = Api._internal();
  Api._internal();

  Dio http = Dio(blueWavesOptions)
    ..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: false,
      ),
    );

  Future<List<Beach>> getAllBeaches() async {
    Response<dynamic> response;
    try {
      response = await http.get('beaches');
      return List<Beach>.generate(
        response.data['beaches'].length,
        (index) => Beach.fromMap(response.data['beaches'][index]),
      );
    } on DioError catch (e) {
      log.e(e.message);
      return <Beach>[];
    }
  }

  Future<Beach?> getBeach({required String id}) async {
    Response<dynamic> response;
    try {
      response = await http.get('beaches/$id');
      return Beach.fromMap(response.data['results']);
    } on DioError catch (e) {
      log.e(e.message);
      return null;
    }
  }

  Future<bool> toggleFavorite({
    required String userId,
    required String beachId,
  }) async {
    try {
      await http.post(
        'favorites/',
        data: {
          'userId': userId,
          'beachId': beachId,
        },
      );
      return true;
    } on DioError catch (e) {
      log.e(e.message);
      return false;
    }
  }

  Future<bool> checkFavorite({
    required String userId,
    required String beachId,
  }) async {
    Response<dynamic> response;
    try {
      response = await http.post(
        'favorites/check',
        data: {
          'userId': userId,
          'beachId': beachId,
        },
      );
      return response.data['results'];
    } on DioError catch (e) {
      log.e(e.message);
      return false;
    }
  }

  Future<String> registerUser(Member user) async {
    final userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: user.email!,
      password: user.password!,
    );
    Response<dynamic> response;
    try {
      response = await http.post(
        'users/',
        data: {
          'id': userCredential.user!.uid,
          'username': user.displayName,
        },
      );
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
    Response<dynamic> response;
    try {
      response = await http.post(
        'users/',
        data: {
          'id': id,
          'username': displayName,
        },
      );
      return response.data['createdAt'];
    } on DioError catch (e) {
      log.e(e.message);
      return e.message;
    }
  }

  Future<bool> checkUser(String id) async {
    Response<dynamic> response;
    try {
      response = await http.post(
        'users/check',
        data: {
          'id': id,
        },
      );
      return response.data['success'];
    } on DioError catch (e) {
      log.e(e.message);
      return false;
    }
  }

  Future<String> addRating(Rating rating) async {
    Response<dynamic> response;
    try {
      response = await http.post(
        'ratings/',
        data: {
          'beachId': rating.beachId,
          'userId': rating.userUid,
          'rating': rating.rating,
          'review': rating.review,
        },
      );
      return response.data['createdAt'];
    } on DioError catch (e) {
      log.e(e.message);
      return e.message;
    }
  }
}
