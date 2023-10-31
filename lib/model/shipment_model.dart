// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipment_model.freezed.dart';
part 'shipment_model.g.dart';

@freezed
class ShipmentModel with _$ShipmentModel {
  factory ShipmentModel({
    required String id,
    @JsonKey(name: 'nomenclature') required String title,
    required String quantity,
    @JsonKey(name: 'MeasureType') required String measureType,
    required String idSeries,
    required String series,
    @JsonKey(name: 'Barcode') String? barcode,
    @Default(false) bool scanned,
  }) = _ShipmentModel;

  factory ShipmentModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentModelFromJson(json);
}
