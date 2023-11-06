import 'package:uboyniy_cex/model/model.dart';

abstract class OrderRepository {
  Future<
      (
        List<SaleOrderModel> sale,
        List<TransferOrderModel> transfer,
        List<MovementOrderModel> movement,
      )> getOrders();
  Future<void> shipOrder(PostOrderModel order, {bool requestFromQueue = false});

  Stream<PostOrderModel> get orders;
  Stream<String> get uploadedOrders;
}
