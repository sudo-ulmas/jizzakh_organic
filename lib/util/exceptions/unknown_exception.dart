import 'package:uboyniy_cex/util/exceptions/exceptions.dart';

class UnkonwnException implements AppException {
  UnkonwnException({this.statusCode});

  final int? statusCode;

  @override
  String message() => 'Что-то пошло не так: код $statusCode';
}
