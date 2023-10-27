import 'package:uboyniy_cex/model/model.dart';

abstract class AnimalRepository {
  Future<List<AnimalModel>> getAnimals();
  Future<void> createDocument();
}
