import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipment_model.freezed.dart';
part 'shipment_model.g.dart';

@freezed
class ShipmentModel with _$ShipmentModel {
  factory ShipmentModel({
    required String id,
    required String title,
    required String productSeries,
    required String count,
    required String barcode,
    @Default(false) bool scanned,
  }) = _ShipmentModel;

  factory ShipmentModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentModelFromJson(json);
}
