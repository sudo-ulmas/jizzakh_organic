import 'dart:math';

import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';

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
    '02 Лошади 12-18 мес откорм',
  ];

  static const _shipmentBarCodes = <String>[
    '23E80397F0208',
    '234020N200C4734',
  ];

  @override
  Future<
      (
        List<SaleOrderModel> sale,
        List<TransferOrderModel> transfer,
        List<MovementOrderModel> movement,
      )> getOrders() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final rng = Random();
    final saleOrders = <SaleOrderModel>[];
    final transferOrders = <TransferOrderModel>[];
    for (var i = 0; i < 100; i += 1) {
      if (i % 3 == 0) {
        saleOrders.add(
          SaleOrderModel(
            id: '${i + 1}',
            receiverName: _orderReceiverNames[rng.nextInt(4)],
            date: _orderDates[rng.nextInt(4)],
            number: '',
            shipments: getShipments(),
          ),
        );
      } else {
        transferOrders.add(
          TransferOrderModel(
            id: '${i + 1}',
            receiverName: _orderReceiverNames[rng.nextInt(4)],
            date: _orderDates[rng.nextInt(4)],
            number: '',
            shipments: getShipments(),
          ),
        );
      }
    }
    return (saleOrders, transferOrders, <MovementOrderModel>[]);
  }

  List<ShipmentModel> getShipments() {
    final rng = Random();
    final shipments = <ShipmentModel>[];
    final length = _shipmentBarCodes.length;
    for (var i = 0; i < length; i += 1) {
      shipments.add(
        ShipmentModel(
          id: '${i + 1}',
          title: _shipmentTitles[rng.nextInt(_shipmentTitles.length)],
          barcode: _shipmentBarCodes[rng.nextInt(length)],
          quantity: rng.nextInt(10000).toString(),
          measureType: 'кг',
          idSeries: rng.nextInt(10000).toString(),
          series: rng.nextInt(10000).toString(),
        ),
      );
    }

    return shipments;
  }

  @override
  Future<void> shipOrder(
    PostOrderModel order, {
    bool requestFromQueue = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Stream<PostOrderModel> get orders => const Stream.empty();

  @override
  Stream<String> get uploadedOrders => const Stream.empty();
}
