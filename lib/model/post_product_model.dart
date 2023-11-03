import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'post_product_model.freezed.dart';
part 'post_product_model.g.dart';

@freezed
@HiveType(typeId: 0)
class PostProductModel with _$PostProductModel {
  factory PostProductModel({
    @HiveField(0) required String id,
    @HiveField(1) required String count,
  }) = _PostProductModel;

  factory PostProductModel.fromJson(Map<String, dynamic> json) =>
      _$PostProductModelFromJson(json);
}
