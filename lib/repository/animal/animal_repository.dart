import 'package:uboyniy_cex/model/model.dart';

// ignore: one_member_abstracts
abstract class AnimalRepository {
  Future<List<AnimalModel>> getAnimals();
}
