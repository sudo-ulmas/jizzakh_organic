import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/util/util.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({required this.order, required this.uploading, super.key});
  final OrderModel order;
  final bool uploading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: uploading
          ? null
          : () => context.go(
                '${PagePath.orders}/${PagePath.shipment}',
                extra: order,
              ),
      title: Text(order.receiverName ?? ''),
      trailing: Text(
        order.date.split(' ').first,
        style: context.theme.textTheme.labelLarge?.copyWith(
          color: context.theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(order.number),
      leading: uploading
          ? const Stack(
              alignment: Alignment.center,
              children: [CircularProgressIndicator(), Icon(Icons.upload)],
            )
          : Icon(
              Icons.edit_document,
              color: order.type.color,
            ),
    );
  }
}
