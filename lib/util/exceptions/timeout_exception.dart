import 'package:uboyniy_cex/util/exceptions/exceptions.dart';

class TimeoutException implements AppException {
  @override
  String message({int? statusCode}) =>
      'Время вышло, проверьте интернет и попробуйте еще раз!';
}
