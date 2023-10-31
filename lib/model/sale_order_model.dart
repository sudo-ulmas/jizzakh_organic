// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';

part 'sale_order_model.freezed.dart';
part 'sale_order_model.g.dart';

@freezed
class SaleOrderModel with _$SaleOrderModel implements OrderModel {
  factory SaleOrderModel({
    @JsonKey(name: 'idsale') required String id,
    @JsonKey(name: 'Number') required String number,
    required String date,
    @JsonKey(name: 'Partner') required String receiverName,
    @JsonKey(name: 'nomenclatures') required List<ShipmentModel> shipments,
    @Default(OrderType.sales) OrderType type,
  }) = _SaleOrderModel;

  factory SaleOrderModel.fromJson(Map<String, dynamic> json) =>
      _$SaleOrderModelFromJson(json);
}
