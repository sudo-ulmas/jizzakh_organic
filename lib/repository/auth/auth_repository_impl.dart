import 'dart:async';

import 'package:uboyniy_cex/model/nomenclature_model.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/util.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  final _controller = StreamController<List<NomenclatureModel>>();

  @override
  Stream<List<NomenclatureModel>> get nomenclatures async* {
    yield* _controller.stream;
  }

  final DioClient _dioClient;
  @override
  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      _dioClient.dio.interceptors.add(
        AuthInterceptor(username: username, password: password),
      );
      final response =
          await _dioClient.dio.post<Map<String, dynamic>>(ApiUrl.products);
      if (response.statusCode == 200) {
        final nomenclatures = (response.data!['nomenclatures'] as List)
            .map((e) => NomenclatureModel.fromJson(e as Map<String, dynamic>))
            .toList();

        _controller.add(nomenclatures);
      }
    } catch (e) {
      _dioClient.dio.interceptors.removeLast();
      //TODO: implement proper error handling
      rethrow;
    }
  }
}
