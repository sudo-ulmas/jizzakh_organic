import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uboyniy_cex/bloc/queue_bloc.dart';
import 'package:uboyniy_cex/presentation/orders/bloc/orders_bloc.dart';
import 'package:uboyniy_cex/presentation/presentation.dart';
import 'package:uboyniy_cex/util/util.dart';
import 'package:uboyniy_cex/widget/widget.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersBloc(
        orderRepository: context.read(),
        localStorageRepository: context.read(),
      )..add(const OrdersEvent.loadOrders()),
      child: Scaffold(
        appBar: SharedAppbar(
          title: 'Распоряжения',
          includeLogoutButton: true,
          actions: [
            IconButton.filledTonal(
              tooltip: 'Нажмите чтобы узнать',
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (context) => const InfoDialog(),
                );
              },
              icon: const Icon(Icons.info_outline),
            ),
          ],
        ),
        body: BlocConsumer<OrdersBloc, OrdersState>(
          builder: (context, state) => switch (state) {
            OrdersSuccess(:final orders) => BlocBuilder<QueueBloc, QueueState>(
                builder: (context, state) => AnimatedList(
                  key: _listKey,
                  initialItemCount: orders.length,
                  itemBuilder: (context, index, animation) => OrderTile(
                    animation: animation,
                    order: orders[index],
                    uploading: state.orders
                        .where((element) => element.id == orders[index].id)
                        .isNotEmpty,
                  ),
                ),
              ),
            OrdersEmpty() => SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.receipt_long,
                      color: Colors.grey,
                      size: 100,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Нет активных распоряжений',
                      style: context.theme.textTheme.titleLarge?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            _ => const Center(
                child: CircularProgressIndicator(),
              )
          },
          listener: (BuildContext context, OrdersState state) {
            if (state is OrdersSuccess) {
              if (state.removeIndex != null) {
                _listKey.currentState?.removeItem(
                  state.removeIndex!,
                  (context, animation) => OrderTile(
                    animation: animation,
                    order: state.removedOrder!,
                    uploading: true,
                  ),
                );
              } else {
                final listItemCount =
                    _listKey.currentState?.widget.initialItemCount ??
                        state.orders.length;
                var newItemCount = state.orders.length - listItemCount;
                while (newItemCount > 0) {
                  _listKey.currentState?.insertItem(0);
                  newItemCount -= 1;
                }
                final oldItemCount = listItemCount - state.orders.length;
                if (oldItemCount > 0) {
                  _listKey.currentState?.removeAllItems(
                    (context, animation) => const SizedBox(),
                  );
                  _listKey.currentState?.insertAllItems(0, state.orders.length);
                }
              }
            } else if (state is OrdersError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.exception.message()),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
