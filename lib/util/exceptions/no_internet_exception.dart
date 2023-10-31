import 'package:uboyniy_cex/util/exceptions/exceptions.dart';

class NoInternetException implements AppException {
  @override
  String message() => 'Кажется, у вас нет доступа к Интернету';
}
