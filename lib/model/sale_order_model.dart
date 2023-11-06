// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uboyniy_cex/model/model.dart';

part 'sale_order_model.freezed.dart';
part 'sale_order_model.g.dart';

@freezed
@HiveType(typeId: 5)
class SaleOrderModel with _$SaleOrderModel implements OrderModel {
  factory SaleOrderModel({
    @HiveField(0) @JsonKey(name: 'idsale') required String id,
    @HiveField(1) @JsonKey(name: 'Number') required String number,
    @HiveField(2) required String date,
    @HiveField(3) @JsonKey(name: 'Partner') required String receiverName,
    @HiveField(4)
    @JsonKey(name: 'nomenclatures')
    required List<ShipmentModel> shipments,
    @Default(OrderType.sales) OrderType type,
  }) = _SaleOrderModel;

  factory SaleOrderModel.fromJson(Map<String, dynamic> json) =>
      _$SaleOrderModelFromJson(json);
}
