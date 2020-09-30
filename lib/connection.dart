import 'package:blue_waves_flutter/models/LoginMemberModel.dart';
import 'package:blue_waves_flutter/models/RegisterMemberModel.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

var logger = Logger();

BaseOptions httpOptions = BaseOptions(
  baseUrl: 'http://10.0.2.2:5000/',
  receiveDataWhenStatusError: true,
  connectTimeout: 6 * 1000, // 6 seconds
  receiveTimeout: 6 * 1000, // 6 seconds
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
    response = await blueWavesHttp.post('api/member/login', data: {
      'userName': lgnMember.userName,
      'password': lgnMember.password,
      'rememberMe': lgnMember.rememberMe,
    });
    logger.i('Loging user.');
    logger.i(response.data);
  } on DioError catch (e) {
    logger.i(e.response.data);
    return e;
  }
  return response.data;
}
