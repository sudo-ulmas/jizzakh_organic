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
    required Stream<dynamic> scannerStream,
  })  : _repository = orderRepository,
        _barcodeScanner = scannerStream,
        super(const ShipmentState.initial()) {
    on<_ShipmentLoadRequested>((e, emit) => _getShipments(emit));
    on<_ShipmentScanned>(_findShipment);
    _barcodeScanner.listen((barcodeText) {
      if (barcodeText != null) {
        add(ShipmentEvent.findShipment(barcodeText as String));
      }
    });
  }

  final OrderRepository _repository;
  final Stream<dynamic> _barcodeScanner;

  void _findShipment(
    _ShipmentScanned event,
    Emitter<ShipmentState> emit,
  ) {
    if (state is ShipmentSuccess) {
      var barcodeNotFound = true;
      var shipments =
          List<ShipmentModel>.from((state as ShipmentSuccess).shipments);
      shipments = shipments.map((e) {
        if (e.barcode == event.barcodeText) {
          barcodeNotFound = false;
          return e.copyWith(scanned: true);
        }
        return e;
      }).toList();
      if (barcodeNotFound) {
        emit(ShipmentState.barcodeNotFound(event.barcodeText));
      }
      emit(ShipmentState.success(shipments));
    }
  }

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
