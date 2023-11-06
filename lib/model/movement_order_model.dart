// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uboyniy_cex/model/model.dart';

part 'movement_order_model.freezed.dart';
part 'movement_order_model.g.dart';

@freezed
@HiveType(typeId: 7)
class MovementOrderModel extends OrderModel with _$MovementOrderModel {
  factory MovementOrderModel({
    @HiveField(0) @JsonKey(name: 'idTOPFP') required String id,
    @HiveField(1) @JsonKey(name: 'Number') required String number,
    @HiveField(2) required String date,
    @HiveField(3)
    @JsonKey(name: 'nomenclatures')
    required List<ShipmentModel> shipments,
    @HiveField(4) @Default('') String? receiverName,
    @Default(OrderType.movement) OrderType type,
  }) = _MovementOrderModel;

  factory MovementOrderModel.fromJson(Map<String, dynamic> json) =>
      _$MovementOrderModelFromJson(json);
}
