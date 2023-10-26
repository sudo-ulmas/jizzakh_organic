import 'dart:math';

import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';

class FakeAnimalRepository implements AnimalRepository {
  static const _animalTitles = <String>[
    '08 Коровы',
    '05 Бычки 12-18 мес откорм',
    '09 Ягненки 1 мес',
    '02 Лошади',
  ];

  static const _animalTags = <String>[
    '10024',
    '1B2.0302',
    '90040',
    '120211',
  ];

  static const _animalParts = <String>[
    'Туша, говядина',
    'Четвертина, говядина ',
    'Голова, корова',
    'Нога, говядина',
  ];
  @override
  Future<List<AnimalModel>> getAnimals() async {
    await Future<void>.delayed(const Duration(microseconds: 300));
    return List.generate(100, (index) {
      final rng = Random();
      return AnimalModel(
        id: index + 1,
        title: _animalTitles[rng.nextInt(4)],
        tag: _animalTags[rng.nextInt(4)],
      );
    });
  }

  @override
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

  @override
  Future<void> createDocument() async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}
