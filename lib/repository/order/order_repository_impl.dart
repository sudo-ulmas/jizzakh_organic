import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<List<OrderModel>> getOrders() {
    throw UnimplementedError();
  }

  @override
  Future<List<ShipmentModel>> getShipments() {
    return Future(() => []);
  }
}
