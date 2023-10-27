// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'animal_model.freezed.dart';
part 'animal_model.g.dart';

@freezed
class AnimalModel with _$AnimalModel {
  factory AnimalModel({
    required String id,
    @JsonKey(name: 'nomenclature') required String title,
    @JsonKey(name: 'id_series') required String tag,
    required int quantity,
    String? weight,
  }) = _AnimalModel;

  factory AnimalModel.fromJson(Map<String, dynamic> json) =>
      _$AnimalModelFromJson(json);
}
