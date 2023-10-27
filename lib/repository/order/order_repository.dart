import 'package:uboyniy_cex/model/model.dart';

// ignore: one_member_abstracts
abstract class OrderRepository {
  Future<List<OrderModel>> getOrders();
  Future<List<ShipmentModel>> getShipments();
}
