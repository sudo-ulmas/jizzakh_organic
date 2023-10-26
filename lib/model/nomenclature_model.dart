// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';

part 'nomenclature_model.freezed.dart';
part 'nomenclature_model.g.dart';

@freezed
class NomenclatureModel with _$NomenclatureModel {
  factory NomenclatureModel({
    required String id,
    @JsonKey(name: 'nomenclature') required String title,
    @JsonKey(name: 'MeasureType') required CountingStrategy countingStrategy,
  }) = _NomenclatureModel;

  factory NomenclatureModel.fromJson(Map<String, dynamic> json) =>
      _$NomenclatureModelFromJson(json);
}
