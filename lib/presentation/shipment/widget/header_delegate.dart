import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:uboyniy_cex/util/util.dart';

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  const HeaderDelegate([this.height = 50]);
  final double height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: context.theme.colorScheme.primaryContainer,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Партия',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.theme.colorScheme.onSurface,
            ),
          ),
          Flexible(
            flex: 3,
            child: AutoSizeText(
              'Номенклатура',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.theme.colorScheme.onSurface,
              ),
              maxLines: 2,
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Кол-во',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
                const Icon(
                  Icons.check_box,
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
