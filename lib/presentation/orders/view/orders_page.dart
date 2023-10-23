import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uboyniy_cex/presentation/orders/bloc/orders_bloc.dart';
import 'package:uboyniy_cex/presentation/presentation.dart';
import 'package:uboyniy_cex/widget/widget.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersBloc(orderRepository: context.read())
        ..add(const OrdersEvent.loadOrders()),
      child: Scaffold(
        appBar: const SharedAppbar(title: 'Распоряжения'),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) => switch (state) {
            OrdersSuccess(:final orders) => ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) => OrderTile(
                  order: orders[index],
                ),
              ),
            _ => const Center(
                child: CircularProgressIndicator(),
              )
          },
        ),
      ),
    );
  }
}
