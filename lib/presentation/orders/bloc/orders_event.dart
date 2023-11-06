part of 'orders_bloc.dart';

@freezed
class OrdersEvent with _$OrdersEvent {
  const factory OrdersEvent.loadOrders() = _OrdersLoadRequested;
  const factory OrdersEvent.uploaded(String id) = _OrdersUploaded;
}
