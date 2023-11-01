// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';

part 'movement_order_model.freezed.dart';
part 'movement_order_model.g.dart';

@freezed
class MovementOrderModel with _$MovementOrderModel implements OrderModel {
  factory MovementOrderModel({
    @JsonKey(name: 'idTOPFP') required String id,
    @JsonKey(name: 'Number') required String number,
    required String date,
    @JsonKey(name: 'nomenclatures') required List<ShipmentModel> shipments,
    @Default('') String? receiverName,
    @Default(OrderType.movement) OrderType type,
  }) = _MovementOrderModel;

  factory MovementOrderModel.fromJson(Map<String, dynamic> json) =>
      _$MovementOrderModelFromJson(json);
}
