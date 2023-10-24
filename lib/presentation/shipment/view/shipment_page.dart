import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uboyniy_cex/presentation/presentation.dart';
import 'package:uboyniy_cex/util/util.dart';
import 'package:uboyniy_cex/widget/widget.dart';

class ShipmentPage extends StatefulWidget {
  const ShipmentPage({super.key});
  static const platform = MethodChannel('com.example.uboyniy_cex/scanner');

  @override
  State<ShipmentPage> createState() => _ShipmentPageState();
}

class _ShipmentPageState extends State<ShipmentPage> {
  final _eventChannel = const EventChannel('com.example.uboyniy_cex/scanner');

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _eventChannel.receiveBroadcastStream().listen(print);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppbar(title: 'Список товаров к отгрузке'),
      body: CustomScrollView(
        slivers: [
          const SliverPersistentHeader(
            pinned: true,
            delegate: HeaderDelegate(),
          ),
          SliverList.builder(
            itemCount: 100,
            itemBuilder: (context, index) => const ShipmentTile(),
          ),
        ],
      ),
    );
  }
}

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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Партия',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            flex: 3,
            child: AutoSizeText(
              'Номенклатура',
              style: TextStyle(
                fontWeight: FontWeight.bold,
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
                  ),
                ),
                Icon(
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
