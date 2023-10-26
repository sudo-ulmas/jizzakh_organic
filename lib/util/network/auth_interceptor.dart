import 'dart:convert';
import 'package:dio/dio.dart';

class AuthInterceptor extends InterceptorsWrapper {
  AuthInterceptor({required this.username, required this.password});

  final String username;
  final String password;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Authorization'] =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    options.headers['Content-Type'] = 'application/json';
    return handler.next(options);
  }
}
