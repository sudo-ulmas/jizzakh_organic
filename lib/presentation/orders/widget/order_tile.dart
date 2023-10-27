import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/util/util.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({required this.order, super.key});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.go('${PagePath.orders}/${PagePath.shipment}'),
      title: Text(order.receverName),
      trailing: Text(
        order.date,
        style: context.theme.textTheme.labelLarge?.copyWith(
          color: context.theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(order.id.toString()),
      leading: Icon(
        Icons.edit_document,
        color: order.type.color,
      ),
    );
  }
}
