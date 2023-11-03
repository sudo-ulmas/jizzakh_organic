import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/presentation/presentation.dart';
import 'package:uboyniy_cex/presentation/shipment/bloc/shipment_bloc.dart';
import 'package:uboyniy_cex/util/util.dart';
import 'package:uboyniy_cex/widget/widget.dart';

class ShipmentPage extends StatefulWidget {
  const ShipmentPage({required this.order, super.key});
  final OrderModel order;
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
        scannerStream: Platform.isAndroid
            ? _eventChannel.receiveBroadcastStream()
            : const Stream.empty(),
        shipments: widget.order.shipments,
        orderRepository: context.read(),
      ),
      child: Scaffold(
        appBar: const SharedAppbar(title: 'Список товаров к отгрузке'),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomScrollView(
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
                          content:
                              Text('${state.barcode} нет в списке товаров'),
                        ),
                      );
                    } else if (state is ShipmentError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.exception.message()),
                        ),
                      );
                    } else if (state is ShipmentSuccess) {
                      context.pop();
                    }
                  },
                  builder: (context, state) => switch (state) {
                    ShipmentInitial(:final shipments) => SliverList.builder(
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
            Positioned(
              bottom: 10,
              left: 24,
              right: 24,
              child: BlocBuilder<ShipmentBloc, ShipmentState>(
                builder: (context, state) {
                  return AnimatedOpacity(
                    opacity: state is ShipmentInitial &&
                            state.shipments.every((element) => element.scanned)
                        ? 1
                        : 0,
                    duration: const Duration(milliseconds: 200),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        onPressed: () => context
                            .read<ShipmentBloc>()
                            .add(ShipmentEvent.shipOrder(order: widget.order)),
                        icon: const Icon(Icons.upload_sharp),
                        label: Text(
                          'Отгрузить',
                          style: context.theme.textTheme.titleMedium?.copyWith(
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
