import 'package:dio/dio.dart';
import 'package:uboyniy_cex/util/util.dart';

class BaseApiHanlder {
  static Future<T> request<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          switch (e.response?.statusCode ?? 0) {
            case 401 || 403:
              throw WrongCredentialsException();
            case 500:
              throw ServerException();
            case _:
              throw UnkonwnException(statusCode: e.response?.statusCode);
          }
        case DioExceptionType.connectionTimeout:
          throw TimeoutException();
        case _:
          throw UnkonwnException(statusCode: e.response?.statusCode);
      }
    } catch (e) {
      throw UnkonwnException();
    }
  }
}
