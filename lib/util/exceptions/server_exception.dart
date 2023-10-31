import 'package:uboyniy_cex/util/exceptions/exceptions.dart';

class ServerException implements AppException {
  @override
  String message({int? statusCode}) =>
      'Что-то не так с сервером, повторите попытку позже!';
}
