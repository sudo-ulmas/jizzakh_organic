import 'package:uboyniy_cex/model/model.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getOrders();
  Future<void> shipOrder(PostOrderModel order, {bool requestFromQueue = false});

  Stream<PostOrderModel> get orders;
  Stream<String> get uploadedOrders;
}
