part of 'orders_bloc.dart';

@freezed
class OrdersState with _$OrdersState {
  const factory OrdersState.initial() = OrdersInitial;

  const factory OrdersState.inProgress() = OrdersInProgress;

  const factory OrdersState.error(AppException exception) = OrdersError;

  const factory OrdersState.success(
    List<OrderModel> orders, {
    int? removeIndex,
    OrderModel? removedOrder,
  }) = OrdersSuccess;
}
