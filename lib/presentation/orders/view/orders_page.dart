import 'package:flutter/material.dart';
import 'package:uboyniy_cex/widget/widget.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SharedAppbar(title: 'Распоряжения'),
    );
  }
}
