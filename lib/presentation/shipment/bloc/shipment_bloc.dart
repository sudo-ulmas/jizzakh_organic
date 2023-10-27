import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';

part 'shipment_event.dart';
part 'shipment_state.dart';
part 'shipment_bloc.freezed.dart';

class ShipmentBloc extends Bloc<ShipmentEvent, ShipmentState> {
  ShipmentBloc({
    required OrderRepository orderRepository,
  })  : _repository = orderRepository,
        super(const ShipmentState.initial()) {
    on<_ShipmentLoadRequested>((e, emit) => _getShipments(emit));
  }

  final OrderRepository _repository;

  Future<void> _getShipments(
    Emitter<ShipmentState> emit,
  ) async {
    try {
      emit(const ShipmentState.inProgress());
      final shipments = await _repository.getShipments();
      emit(ShipmentState.success(shipments));
    } catch (e) {
      emit(const ShipmentState.error());
    }
  }
}
