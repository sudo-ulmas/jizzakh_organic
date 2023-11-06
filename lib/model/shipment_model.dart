// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'shipment_model.freezed.dart';
part 'shipment_model.g.dart';

@freezed
@HiveType(typeId: 4)
class ShipmentModel with _$ShipmentModel {
  factory ShipmentModel({
    @HiveField(0) required String id,
    @HiveField(1) @JsonKey(name: 'nomenclature') required String title,
    @HiveField(2) required String quantity,
    @HiveField(3) @JsonKey(name: 'MeasureType') required String measureType,
    @HiveField(4) required String idSeries,
    @HiveField(5) required String series,
    @HiveField(6) @JsonKey(name: 'Barcode') String? barcode,
    @Default(false) bool scanned,
  }) = _ShipmentModel;

  factory ShipmentModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentModelFromJson(json);
}
