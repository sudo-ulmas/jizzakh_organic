import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';

part 'animal_part_model.freezed.dart';
part 'animal_part_model.g.dart';

@freezed
class AnimalPartModel with _$AnimalPartModel {
  factory AnimalPartModel({
    required int listIndex,
    required NomenclatureModel nomenclature,
    required String count,
  }) = _AnimalPartModel;

  factory AnimalPartModel.fromJson(Map<String, dynamic> json) =>
      _$AnimalPartModelFromJson(json);

  factory AnimalPartModel.empty(int index) => AnimalPartModel(
        listIndex: index,
        nomenclature: NomenclatureModel(
          id: 0,
          title: '',
          countingStrategy: CountingStrategy.weight,
        ),
        count: '',
      );
}
