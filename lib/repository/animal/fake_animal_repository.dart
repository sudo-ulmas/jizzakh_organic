import 'dart:math';

import 'package:uboyniy_cex/model/animal_model.dart';
import 'package:uboyniy_cex/repository/repository.dart';

class FakeAnimalRepository implements AnimalRepository {
  static const _titles = <String>[
    '08 Коровы',
    '05 Бычки 12-18 мес откорм',
    '09 Ягненки 1 мес',
    '02 Лошади',
  ];

  static const _tags = <String>[
    '10024',
    '1B2.0302',
    '90040',
    '120211',
  ];
  @override
  Future<List<AnimalModel>> getAnimals() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return List.generate(100, (index) {
      final rng = Random();
      return AnimalModel(
        id: index + 1,
        title: _titles[rng.nextInt(4)],
        tag: _tags[rng.nextInt(4)],
      );
    });
  }
}
