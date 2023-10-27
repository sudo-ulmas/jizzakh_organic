import 'package:uboyniy_cex/model/animal_model.dart';
import 'package:uboyniy_cex/repository/repository.dart';

class AnimalRepositoryDecorator implements AnimalRepository {
  AnimalRepositoryDecorator({
    required AnimalRepositoryImpl animalRepositoryImpl,
    required FakeAnimalRepository fakeAnimalRepository,
  })  : _animalRepositoryImpl = animalRepositoryImpl,
        _fakeAnimalRepository = fakeAnimalRepository;

  final AnimalRepositoryImpl _animalRepositoryImpl;
  final FakeAnimalRepository _fakeAnimalRepository;

  @override
  Future<void> createDocument() {
    return _fakeAnimalRepository.createDocument();
  }

  @override
  Future<List<AnimalModel>> getAnimals() {
    return _animalRepositoryImpl.getAnimals();
  }
}
