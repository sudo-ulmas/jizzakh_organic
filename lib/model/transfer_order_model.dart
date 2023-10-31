// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';

part 'transfer_order_model.freezed.dart';
part 'transfer_order_model.g.dart';

@freezed
class TransferOrderModel with _$TransferOrderModel implements OrderModel {
  factory TransferOrderModel({
    @JsonKey(name: 'idOrder') required String id,
    @JsonKey(name: 'Number') required String number,
    required String date,
    @JsonKey(name: 'storage') required String receiverName,
    @JsonKey(name: 'nomenclatures') required List<ShipmentModel> shipments,
    @Default(OrderType.transfer) OrderType type,
  }) = _TransferOrderModel;

  factory TransferOrderModel.fromJson(Map<String, dynamic> json) =>
      _$TransferOrderModelFromJson(json);
}
