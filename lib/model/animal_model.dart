import 'package:freezed_annotation/freezed_annotation.dart';

part 'animal_model.freezed.dart';
part 'animal_model.g.dart';

@freezed
class AnimalModel with _$AnimalModel {
  factory AnimalModel({
    required int id,
    required String title,
    required String tag,
    String? weight,
  }) = _AnimalModel;

  factory AnimalModel.fromJson(Map<String, dynamic> json) =>
      _$AnimalModelFromJson(json);
}
