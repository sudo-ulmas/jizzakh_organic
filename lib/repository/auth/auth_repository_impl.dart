import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
      return await BaseApiHanlder.request(() async {
        final response =
            await _dioClient.dio.post<Map<String, dynamic>>(ApiUrl.products);
        final nomenclatures = (response.data!['nomenclatures'] as List)
            .map((e) => NomenclatureModel.fromJson(e as Map<String, dynamic>))
            .toList();
        await _savePassword(username: username, password: password);
        _controller.add(nomenclatures);
      });
    } on AppException {
      _dioClient.dio.interceptors.removeLast();
      rethrow;
    }
  }

  @override
  Future<String?> getPassword({required String username}) async {
    const secureStorage = FlutterSecureStorage();
    final password = await secureStorage.read(key: username);

    return password;
  }

  Future<void> _savePassword({
    required String username,
    required String password,
  }) async {
    const secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: username, value: password);
  }
}
