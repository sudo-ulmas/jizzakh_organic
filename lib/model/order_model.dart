import 'package:uboyniy_cex/model/model.dart';

abstract class OrderModel {
  OrderModel({
    required this.id,
    required this.receiverName,
    required this.number,
    required this.date,
    required this.shipments,
    required this.type,
  });

  final String id;
  final String? receiverName;
  final String date;
  final String number;
  final List<ShipmentModel> shipments;
  final OrderType type;
}
