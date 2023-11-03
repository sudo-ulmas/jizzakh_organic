// ignore_for_file: unused_field

import 'package:uboyniy_cex/model/model.dart';
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
  Future<void> createDocument(
    PostDocumentModel documentModel, {
    bool requestFromQueue = false,
  }) {
    return _animalRepositoryImpl.createDocument(
      documentModel,
      requestFromQueue: requestFromQueue,
    );
  }

  @override
  Future<List<AnimalModel>> getAnimals() {
    return _animalRepositoryImpl.getAnimals();
  }

  @override
  Stream<PostDocumentModel> get documents => _animalRepositoryImpl.documents;

  @override
  Stream<String> get uploadedDocumentIds =>
      _animalRepositoryImpl.uploadedDocumentIds;
}
