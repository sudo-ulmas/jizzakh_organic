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

  static const _shipmentTitles = <String>[
    '08 Коровы',
    '05 Бычки 12-18 мес откорм',
    '09 Ягненки 1 мес',
    '02 Лошади',
  ];

  static const _shipmentCounts = <String>[
    '300 кг',
    '467 кг',
    '58 комп',
    '30 шт',
  ];

  static const _shipmentBarCodes = <String>[
    '123123123',
    '123123123',
    '123123123',
    '123123123',
  ];

  @override
  Future<List<OrderModel>> getOrders() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
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

  @override
  Future<List<ShipmentModel>> getShipments() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final rng = Random();
    final shipments = <ShipmentModel>[];
    for (var i = 0; i < 12; i += 1) {
      shipments.add(
        ShipmentModel(
          id: '${i + 1}',
          title: _shipmentTitles[rng.nextInt(4)],
          productSeries: rng.nextInt(10000).toString(),
          count: _shipmentCounts[rng.nextInt(4)],
          barcode: _shipmentBarCodes[rng.nextInt(4)],
        ),
      );
    }

    return shipments;
  }
}
