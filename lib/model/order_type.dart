import 'package:flutter/material.dart';

enum OrderType {
  transfer(name: 'Передача продукции из производства', color: Colors.blue),
  sales(name: 'Реализация товаров и услуг', color: Colors.green);

  const OrderType({required this.name, required this.color});
  final String name;
  final Color color;
}
