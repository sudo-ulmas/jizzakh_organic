import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';

class OrderRepositoryDecorator implements OrderRepository {
  OrderRepositoryDecorator({
    required OrderRepositoryImpl orderRepositoryImpl,
    required FakeOrderRepository fakeOrderRepository,
  })  : _orderRepository = orderRepositoryImpl,
        _fakeOrderRepository = fakeOrderRepository;

  final OrderRepository _orderRepository;
  // ignore: unused_field
  final OrderRepository _fakeOrderRepository;
  @override
  Future<
      (
        List<SaleOrderModel> sale,
        List<TransferOrderModel> transfer,
        List<MovementOrderModel> movement,
      )> getOrders() async {
    final orders = await _orderRepository.getOrders();

    return orders;
  }

  @override
  Future<void> shipOrder(
    PostOrderModel order, {
    bool requestFromQueue = false,
  }) async {
    await _orderRepository.shipOrder(order);
  }

  @override
  Stream<PostOrderModel> get orders => _orderRepository.orders;

  @override
  Stream<String> get uploadedOrders => _orderRepository.uploadedOrders;
}
