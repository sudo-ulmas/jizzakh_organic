import 'package:uboyniy_cex/util/exceptions/exceptions.dart';

class TimeoutException implements AppException {
  @override
  String message({int? statusCode}) =>
      'Похоже, что сервер долго не отвечает, пожалуйста, попробуйте еще раз';
}
