import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/util/util.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          'Информация по рапоряжениям',
          style: TextStyle(
            color: context.theme.colorScheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.edit_document,
                  color: Colors.blue,
                ),
                Flexible(
                  child: Text(
                    ' ${OrderType.transfer.name}',
                    style: TextStyle(
                      color: context.theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.edit_document,
                  color: Colors.green,
                ),
                Flexible(
                  child: Text(
                    ' ${OrderType.sales.name}',
                    style: TextStyle(
                      color: context.theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.edit_document,
                  color: Colors.yellow,
                ),
                Flexible(
                  child: Text(
                    ' ${OrderType.movement.name}',
                    style: TextStyle(
                      color: context.theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Понятно'),
          ),
        ],
      );
}
