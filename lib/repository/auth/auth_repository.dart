import 'package:uboyniy_cex/model/model.dart';

abstract class AuthRepository {
  Stream<List<NomenclatureModel>> get nomenclatures;
  Future<void> login({
    required String username,
    required String password,
  });

  Future<String?> getPassword({required String username});
}
