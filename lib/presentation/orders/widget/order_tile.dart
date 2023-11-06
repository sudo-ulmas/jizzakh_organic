import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/util/util.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    required this.order,
    required this.uploading,
    required this.animation,
    super.key,
  });
  final OrderModel order;
  final bool uploading;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        onTap: uploading
            ? null
            : () => context.go(
                  '${PagePath.orders}/${PagePath.shipment}',
                  extra: order,
                ),
        title: Text(
          order.receiverName ?? '',
          style: context.theme.textTheme.bodyLarge?.copyWith(
            color:
                uploading ? Colors.grey : context.theme.colorScheme.onSurface,
          ),
        ),
        trailing: Text(
          order.date.split(' ').first,
          style: context.theme.textTheme.labelLarge?.copyWith(
            color:
                uploading ? Colors.grey : context.theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.number,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: uploading
                    ? Colors.grey
                    : context.theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            if (uploading)
              const Row(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Готовится к отправке',
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
          ],
        ),
        leading: Icon(
          Icons.edit_document,
          color: order.type.color.withOpacity(uploading ? 0.5 : 1),
        ),
      ),
    );
  }
}
