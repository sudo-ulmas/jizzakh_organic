import 'package:flutter/material.dart';
import 'package:uboyniy_cex/util/util.dart';

enum OrderType {
  transfer(
    name: 'Передача продукции из производства',
    color: Colors.blue,
    url: ApiUrl.shipTransformOrder,
    idKey: 'idOrder',
  ),
  movement(
    name: 'Движение продукции и материалов',
    color: Colors.yellow,
    url: ApiUrl.shipMovementOrder,
    idKey: 'idTOPFP',
  ),
  sales(
    name: 'Реализация товаров и услуг',
    color: Colors.green,
    url: ApiUrl.shipSaleOrder,
    idKey: 'idSale',
  );

  const OrderType({
    required this.name,
    required this.color,
    required this.url,
    required this.idKey,
  });
  final String name;
  final Color color;
  final String url;
  final String idKey;
}
