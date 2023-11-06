// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uboyniy_cex/model/model.dart';

part 'transfer_order_model.freezed.dart';
part 'transfer_order_model.g.dart';

@freezed
@HiveType(typeId: 6)
class TransferOrderModel extends OrderModel with _$TransferOrderModel {
  factory TransferOrderModel({
    @HiveField(0) @JsonKey(name: 'idOrder') required String id,
    @HiveField(1) @JsonKey(name: 'Number') required String number,
    @HiveField(2) required String date,
    @HiveField(3) @JsonKey(name: 'storage') required String receiverName,
    @HiveField(4)
    @JsonKey(name: 'nomenclatures')
    required List<ShipmentModel> shipments,
    @Default(OrderType.transfer) OrderType type,
  }) = _TransferOrderModel;

  factory TransferOrderModel.fromJson(Map<String, dynamic> json) =>
      _$TransferOrderModelFromJson(json);
}
