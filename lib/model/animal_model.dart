// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'animal_model.freezed.dart';
part 'animal_model.g.dart';

@freezed
@HiveType(typeId: 3)
class AnimalModel with _$AnimalModel {
  factory AnimalModel({
    @HiveField(0) required String id,
    @HiveField(1) @JsonKey(name: 'nomenclature') required String title,
    @HiveField(2) @JsonKey(name: 'series') required String tag,
    @HiveField(3) required String idSeries,
    @HiveField(4) required num quantity,
    String? weight,
  }) = _AnimalModel;

  factory AnimalModel.fromJson(Map<String, dynamic> json) =>
      _$AnimalModelFromJson(json);
}
