import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/util.dart';

part 'orders_event.dart';
part 'orders_state.dart';
part 'orders_bloc.freezed.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc(
      {required OrderRepository orderRepository,
      required LocalStorageRepository localStorageRepository})
      : _repository = orderRepository,
        _localStorageRepository = localStorageRepository,
        super(const OrdersState.initial()) {
    on<_OrdersLoadRequested>((e, emit) => _getOrders(emit));
    on<_OrdersUploaded>(_removeOrder);

    _streamSubscription = _repository.uploadedOrders.listen((event) {
      add(OrdersEvent.uploaded(event));
    });
  }

  final OrderRepository _repository;
  final LocalStorageRepository _localStorageRepository;
  late StreamSubscription<String> _streamSubscription;

  Future<void> _removeOrder(
    _OrdersUploaded event,
    Emitter<OrdersState> emit,
  ) async {
    if (state is OrdersSuccess) {
      late int? removeIndex;
      late OrderModel? removedOrder;
      final orders = List<OrderModel>.from((state as OrdersSuccess).orders);
      orders.removeWhere((element) {
        if (element.id == event.id) {
          removeIndex = orders.indexOf(element);
          removedOrder = element;
        }
        return element.id == event.id;
      });
      emit(
        OrdersSuccess(
          orders,
          removeIndex: removeIndex,
          removedOrder: removedOrder,
        ),
      );
    }
  }

  Future<void> _getOrders(
    Emitter<OrdersState> emit,
  ) async {
    late List<OrderModel> ordersFromLocalDb;
    try {
      emit(const OrdersState.inProgress());
      ordersFromLocalDb = await _localStorageRepository.getOrders();
      if (ordersFromLocalDb.isNotEmpty) {
        emit(OrdersState.success(ordersFromLocalDb));
      }
      final orders = await _repository.getOrders();
      final orderList = [...orders.$1, ...orders.$2, ...orders.$3];
      if (orderList.isEmpty) {
        emit(const OrdersState.empty());
      } else {
        emit(OrdersState.success(orderList));
      }
      await _localStorageRepository.saveOrders(orders);
    } on AppException catch (e) {
      emit(OrdersState.error(e));
      if (ordersFromLocalDb.isEmpty) {
        emit(const OrdersState.empty());
      } else {
        emit(OrdersState.success(ordersFromLocalDb));
      }
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
