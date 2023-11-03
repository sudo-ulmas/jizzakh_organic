import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uboyniy_cex/model/model.dart';

part 'post_document_model.freezed.dart';
part 'post_document_model.g.dart';

@freezed
@HiveType(typeId: 1)
class PostDocumentModel with _$PostDocumentModel {
  factory PostDocumentModel({
    @HiveField(0) required String idNomenclature,
    @HiveField(1) required String weight,
    @HiveField(2) required List<PostProductModel> products,
  }) = _PostDocumentModel;

  factory PostDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$PostDocumentModelFromJson(json);

  factory PostDocumentModel.fromAnimal(
    AnimalModel animal,
    List<AnimalPartModel> animalParts,
  ) =>
      PostDocumentModel(
        idNomenclature: animal.id,
        weight: animal.weight!,
        products: animalParts
            .map((e) => PostProductModel(id: e.nomenclature.id, count: e.count))
            .toList(),
      );
}
