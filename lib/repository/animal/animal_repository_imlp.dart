import 'package:uboyniy_cex/model/animal_model.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/util.dart';

class AnimalRepositoryImpl implements AnimalRepository {
  AnimalRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<void> createDocument() {
    throw UnimplementedError();
  }

  @override
  Future<List<AnimalModel>> getAnimals() async {
    try {
      final response =
          await _dioClient.dio.post<Map<String, dynamic>>(ApiUrl.nomenclatures);

      if (response.statusCode == 200) {
        final animals = (response.data!['nomenclatures'] as List)
            .map((e) => AnimalModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return animals;
      }
      throw Exception(response.statusCode);
    } catch (e) {
      //TODO: make this beatifull
      rethrow;
    }
  }
}
