import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String _baseUrl = 'https://cz5403.eudc.cloud/Tuychiev_JO/hs/Mobile_JO';

class DioClient {
  DioClient();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      followRedirects: false,
      validateStatus: (status) {
        if (status != null) {
          return status < 500;
        }
        return false;
      },
      receiveTimeout: const Duration(seconds: 20),
      connectTimeout: const Duration(seconds: 20),
    ),
  )..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ),
    );
}

abstract class ApiUrl {
  static const String nomenclatures = '/Nomenclatures/';
  static const String products = '/Products/';
  static const String createDocument = '/ProductionWithoutOrder/';
  static const String orders = '/OrderForMoving/';
}
