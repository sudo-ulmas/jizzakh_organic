import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/util/util.dart';

class ShipmentTile extends StatelessWidget {
  const ShipmentTile({required this.shipment, super.key});

  final ShipmentModel shipment;

  @override
  Widget build(BuildContext context) {
    final onSurfaceColor = context.theme.colorScheme.onSurface;
    final bodyMediumStyle = context.theme.textTheme.bodyMedium;
    return Card(
      margin: EdgeInsets.zero,
      shape: LinearBorder.none,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Text(
                    shipment.idSeries,
                    style: bodyMediumStyle?.copyWith(color: onSurfaceColor),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 1,
                    height: 22,
                    color: Colors.blueGrey,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    shipment.title,
                    textAlign: TextAlign.center,
                    style: bodyMediumStyle?.copyWith(color: onSurfaceColor),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 1,
              height: 22,
              color: Colors.blueGrey,
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: AutoSizeText(
                      '${shipment.quantity} ${shipment.measureType}',
                      style: bodyMediumStyle?.copyWith(color: onSurfaceColor),
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: 1,
                    height: 22,
                    color: Colors.blueGrey,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 12),
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: shipment.scanned ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
