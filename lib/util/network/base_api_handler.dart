import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:uboyniy_cex/util/util.dart';

class BaseApiHanlder {
  static Future<T> request<T>(Future<T> Function() request) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.ethernet) {
        return await request();
      } else {
        throw NoInternetException();
      }
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
        case DioExceptionType.connectionTimeout ||
              DioExceptionType.receiveTimeout:
          throw TimeoutException();
        case _:
          throw UnkonwnException(statusCode: e.response?.statusCode);
      }
    } on NoInternetException {
      rethrow;
    } catch (e) {
      throw UnkonwnException();
    }
  }
}
