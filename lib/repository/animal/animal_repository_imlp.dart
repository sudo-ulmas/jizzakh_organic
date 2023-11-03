import 'dart:async';

import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/util.dart';

class AnimalRepositoryImpl implements AnimalRepository {
  AnimalRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Stream<PostDocumentModel> get documents async* {
    yield* _documentsStreamController.stream;
  }

  final _documentsStreamController = StreamController<PostDocumentModel>();

  @override
  Future<void> createDocument(
    PostDocumentModel document, {
    bool requestFromQueue = false,
  }) async {
    try {
      return await BaseApiHanlder.request(() async {
        await _dioClient.dio.post<Map<String, dynamic>>(
          ApiUrl.createDocument,
          data: {
            'nomenclature': document.toJson(),
          },
        );
      });
    } on NoInternetException {
      if (requestFromQueue) {
        rethrow;
      }
      _documentsStreamController.add(document);
    } on TimeoutException {
      if (requestFromQueue) {
        rethrow;
      }
      _documentsStreamController.add(document);
    } catch (e) {
      rethrow;
    }
  }

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
