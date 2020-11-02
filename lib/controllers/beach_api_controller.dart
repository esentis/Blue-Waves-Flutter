import 'package:Blue_Waves/models/Beach.dart';
import 'package:dio/dio.dart';

import '../connection.dart';

/// HTTP connection settings.
BaseOptions dioOptions = BaseOptions(
    baseUrl: 'http://10.0.2.2:3000',
    receiveDataWhenStatusError: true,
    connectTimeout: 6 * 1000, // 6 seconds
    receiveTimeout: 6 * 1000 // 6 seconds
    );
Dio dio = Dio(dioOptions);

Future<Object> addBeachToApi({Beach beach}) async {
  Response response;
  try {
    response = await dio.post('/beaches/add', data: {
      'name': beach.name,
      'description': beach.description,
      'longitude': beach.longitude,
      'latitude': beach.latitude,
      'images': beach.images,
    });
    logger.v(response);
  } on DioError catch (e) {
    logger.e(e.message);
    return e.type;
  }
  return response;
}

Future searchBeach(String term) async {
  Response response;
  try {
    response = await dio.post(
      '/beaches/search',
      data: {
        'term': term,
      },
    );
    return response.data;
  } on DioError catch (e) {
    logger.e(e.message);
    return e.type;
  }
}

Future getBeachesApi() async {
  Response response;
  try {
    response = await dio.get('/beaches');
    logger.wtf(response);
  } on DioError catch (e) {
    logger.e(e.message);
    return e.type;
  }
}

Future getAllBeachesApi() async {
  Response response;
  try {
    response = await dio.get('/beaches/all');
    // logger.wtf(response.data);
    return response.data;
  } on DioError catch (e) {
    logger.e(e.message);
    return e.type;
  }
}
