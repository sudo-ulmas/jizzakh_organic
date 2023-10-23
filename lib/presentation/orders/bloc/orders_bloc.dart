import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';
part 'orders_bloc.freezed.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc({
    required OrderRepository orderRepository,
  })  : _repository = orderRepository,
        super(const OrdersState.initial()) {
    on<_OrdersLoadRequested>((e, emit) => _getOrders(emit));
  }

  final OrderRepository _repository;

  Future<void> _getOrders(
    Emitter<OrdersState> emit,
  ) async {
    try {
      emit(const OrdersState.inProgress());
      final orders = await _repository.getOrders();
      emit(OrdersState.success(orders));
    } catch (e) {
      emit(const OrdersState.error());
    }
  }
}
