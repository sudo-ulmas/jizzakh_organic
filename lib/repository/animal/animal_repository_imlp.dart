import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/util.dart';

class AnimalRepositoryImpl implements AnimalRepository {
  AnimalRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<void> createDocument(
    (AnimalModel, List<AnimalPartModel>) nomenclature,
  ) =>
      BaseApiHanlder.request(() async {
        await _dioClient.dio.post<Map<String, dynamic>>(
          ApiUrl.createDocument,
          data: {
            'nomenclature': {
              'id_nomenclature': nomenclature.$1.id,
              'weight': nomenclature.$1.weight,
              'products': nomenclature.$2
                  .map((e) => {'id': e.nomenclature.id, 'count': e.count})
                  .toList(),
            },
          },
        );
      });

  @override
  Future<List<AnimalModel>> getAnimals() => BaseApiHanlder.request(() async {
        final response = await _dioClient.dio
            .post<Map<String, dynamic>>(ApiUrl.nomenclatures);
        final animals = (response.data!['nomenclatures'] as List)
            .map((e) => AnimalModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return animals;
      });
}
