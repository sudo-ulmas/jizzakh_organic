import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uboyniy_cex/presentation/presentation.dart';
import 'package:uboyniy_cex/presentation/shipment/bloc/shipment_bloc.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShipmentBloc(
        orderRepository: context.read(),
        scannerStream: Platform.isAndroid
            ? _eventChannel.receiveBroadcastStream()
            : const Stream.empty(),
      )..add(const ShipmentEvent.loadShipment()),
      child: Scaffold(
        appBar: const SharedAppbar(title: 'Список товаров к отгрузке'),
        body: CustomScrollView(
          slivers: [
            const SliverPersistentHeader(
              pinned: true,
              delegate: HeaderDelegate(),
            ),
            BlocConsumer<ShipmentBloc, ShipmentState>(
              listener: (context, state) {
                if (state is ShipmentBarcodeNotFound) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${state.barcode} нет в списке товаров'),
                    ),
                  );
                }
              },
              builder: (context, state) => switch (state) {
                ShipmentSuccess(:final shipments) => SliverList.builder(
                    itemCount: shipments.length,
                    itemBuilder: (context, index) => ShipmentTile(
                      shipment: shipments[index],
                    ),
                  ),
                _ => const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
