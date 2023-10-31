import 'package:uboyniy_cex/util/exceptions/exceptions.dart';

class WrongCredentialsException implements AppException {
  @override
  String message({int? statusCode}) =>
      'Не удалось найти пользователя с такими учетными данными.';
}
