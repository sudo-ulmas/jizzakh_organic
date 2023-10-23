import 'dart:math';

import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/order/order_repository.dart';

class FakeOrderRepository implements OrderRepository {
  static const _orderReceiverNames = <String>[
    'Иванов И.И',
    'Саховат бройлер',
    'Василиев А А',
    'Дуров А А',
  ];

  static const _orderDates = <String>[
    '12.01.2023',
    '13.05.2022',
    '18.09.2019',
    '19.02.2024',
  ];
  @override
  Future<List<OrderModel>> getOrders() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final rng = Random();
    final orders = <OrderModel>[];
    for (var i = 0; i < 100; i += 1) {
      orders.add(
        OrderModel(
          id: i + 1,
          receverName: _orderReceiverNames[rng.nextInt(4)],
          date: _orderDates[rng.nextInt(4)],
          type: rng.nextBool() ? OrderType.sales : OrderType.transfer,
        ),
      );
    }
    return orders;
  }
}
