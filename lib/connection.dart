import 'dart:convert';

import 'package:blue_waves_flutter/models/BeacModel.dart';
import 'package:blue_waves_flutter/models/LoginMemberModel.dart';
import 'package:blue_waves_flutter/models/RegisterMemberModel.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

var logger = Logger();

BaseOptions httpOptions = BaseOptions(
    baseUrl: 'http://10.0.2.2:5000/',
    receiveDataWhenStatusError: true,
    connectTimeout: 6 * 1000, // 6 seconds
    receiveTimeout: 6 * 1000,
    headers: {'Content-Type': 'application/json'} // 6 seconds
    );
Dio blueWavesHttp = Dio(httpOptions);

/// Returns all beaches.
Future getBeaches() async {
  Response response;
  try {
    response = await blueWavesHttp.get('api/beach', queryParameters: {
      'page': 1,
      'itemsPerPage': 10,
    });
    logger.i('Getting all beaches.');
    logger.i(response.data);
  } on DioError catch (e) {
    logger.i(e);
    return e.type;
  }
  return response.data;
}

/// Adds a beach. [beach] has Name, Description , Latitude and Longitude
Future addBeach(Beach beach) async {
  Response response;
  try {
    response = await blueWavesHttp.post('api/beach', data: {
      'name': beach.name,
      'description': beach.description,
      'latitude': beach.latitude,
      'longitude': beach.longitute,
    });
    logger.i('Adding beach.');
    logger.i(response.data);
  } on DioError catch (e) {
    logger.i(e.response.data);
    return e;
  }
  return response.data;
}

/// Registers a member. [rMember] has Username, Email, Password and ConfirmPassword
Future registerMember(RegisterMemberModel rMember) async {
  Response response;
  try {
    response = await blueWavesHttp.post('api/member/register', data: {
      'userName': rMember.userName,
      'email': rMember.email,
      'password': rMember.password,
      'confirmPassword': rMember.confirmPassword,
    });
    logger.i('Registering user.');
    logger.i(response.data);
  } on DioError catch (e) {
    logger.i(e.response.data);
    return e;
  }
  return response.data;
}

/// Logs in a user. [lgnMember] has Username, Password and RememberMe
Future loginMember(LoginMemberModel lgnMember) async {
  Response response;
  try {
    var gettokenuri = Uri(
        scheme: 'http',
        //      host: '10.0.2.2',
        port: 5000,
        host: '10.0.2.2',
        path: '/Token');

    //the user name and password along with the grant type are passed the body as text.
    //and the contentype must be x-www-form-urlencoded
    var loginInfo = 'UserName=' +
        lgnMember.userName +
        '&Password=' +
        lgnMember.password +
        '&grant_type=password';
    response = await blueWavesHttp.post('api/member/login', data: {
      'userName': lgnMember.userName,
      'password': lgnMember.password,
      'rememberMe': lgnMember.rememberMe,
    });
    var response2 = await http.post(gettokenuri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: loginInfo);

    logger.wtf(response2.headers);
    logger.wtf(response2.request);
    logger.wtf(response2.persistentConnection);
    logger.wtf(response2.contentLength);
  } on DioError catch (e) {
    logger.i(e.response.data);
    return e;
  }
  return response.data;
}
