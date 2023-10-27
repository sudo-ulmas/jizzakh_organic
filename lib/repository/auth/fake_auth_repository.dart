import 'dart:math';

import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/auth/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  static const _animalParts = <String>[
    'Туша, говядина',
    'Четвертина, говядина ',
    'Голова, корова',
    'Нога, говядина',
  ];

  @override
  Future<void> login({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Stream<List<NomenclatureModel>> get nomenclatures async* {
    yield await getNomenclatures();
  }

  Future<List<NomenclatureModel>> getNomenclatures() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.generate(100, (index) {
      final rng = Random();
      return NomenclatureModel(
        id: '${index + 1}',
        title: _animalParts[rng.nextInt(4)],
        countingStrategy: CountingStrategy.values[rng.nextInt(2)],
      );
    });
  }
}
