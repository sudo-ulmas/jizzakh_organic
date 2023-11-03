import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:uboyniy_cex/model/model.dart';

part 'post_order_model.freezed.dart';
part 'post_order_model.g.dart';

@freezed
@HiveType(typeId: 2)
class PostOrderModel with _$PostOrderModel {
  factory PostOrderModel({
    @HiveField(0) required String url,
    @HiveField(1) required String idKey,
    @HiveField(2) required String id,
  }) = _PostOrderModel;

  factory PostOrderModel.fromJson(Map<String, dynamic> json) =>
      _$PostOrderModelFromJson(json);

  factory PostOrderModel.fromOrder(OrderModel order) => PostOrderModel(
        url: order.type.url,
        idKey: order.type.idKey,
        id: order.id,
      );
}
