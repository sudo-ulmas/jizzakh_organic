import 'package:uboyniy_cex/model/order_model.dart';
import 'package:uboyniy_cex/repository/repository.dart';

class OrderRepositoryDecorator implements OrderRepository {
  OrderRepositoryDecorator({
    required OrderRepositoryImpl orderRepositoryImpl,
    required FakeOrderRepository fakeOrderRepository,
  })  : _orderRepository = orderRepositoryImpl,
        _fakeOrderRepository = fakeOrderRepository;

  final OrderRepository _orderRepository;
  final OrderRepository _fakeOrderRepository;
  @override
  Future<List<OrderModel>> getOrders() async {
    final fakeOrders = await _fakeOrderRepository.getOrders();
    final orders = await _orderRepository.getOrders();

    return [fakeOrders.first, ...orders];
  }

  @override
  Future<void> shipOrder(OrderModel order) async {
    await _orderRepository.shipOrder(order);
  }
}
