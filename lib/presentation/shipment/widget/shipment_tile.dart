import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ShipmentTile extends StatelessWidget {
  const ShipmentTile({super.key});

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        shape: LinearBorder.none,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('12313'),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 1,
                height: 22,
                color: Colors.blueGrey,
              ),
              const Flexible(
                flex: 4,
                child: AutoSizeText(
                  'Четвертина говядина говядина',
                  maxLines: 2,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 1,
                height: 22,
                color: Colors.blueGrey,
              ),
              const Text('1234 кг'),
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: 1,
                height: 22,
                color: Colors.blueGrey,
              ),
              Container(
                margin: const EdgeInsets.only(left: 12),
                width: 11,
                height: 11,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      );

  // ListTile(
  //       leading: Text('12313'),
  //       title: Text(
  //         'Четвертина говядина',
  //         textAlign: TextAlign.center,
  //       ),
  //       trailing: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           VerticalDivider(
  //             thickness: 2,
  //             indent: 13,
  //             endIndent: 13,
  //             color: Colors.blueGrey,
  //           ),
  //           Text('123 кг'),
  //           VerticalDivider(
  //             thickness: 2,
  //             indent: 13,
  //             endIndent: 13,
  //             color: Colors.blueGrey,
  //           ),
  //           Container(
  //             width: 10,
  //             height: 10,
  //             color: Colors.green,
  //           ),
  //         ],
  //       ),
  //     );
}
