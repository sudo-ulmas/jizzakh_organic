import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/util.dart';

part 'shipment_event.dart';
part 'shipment_state.dart';
part 'shipment_bloc.freezed.dart';

class ShipmentBloc extends Bloc<ShipmentEvent, ShipmentState> {
  ShipmentBloc({
    required Stream<dynamic> scannerStream,
    required List<ShipmentModel> shipments,
    required OrderRepository orderRepository,
  })  : _barcodeScanner = scannerStream,
        _repository = orderRepository,
        super(ShipmentState.initial(shipments)) {
    on<_ShipmentScanned>(_findShipment);
    on<_ShipmentShipOrderPressed>(_shipOrder);
    _barcodeScanner.listen((barcodeText) {
      if (barcodeText != null) {
        add(ShipmentEvent.findShipment(barcodeText as String));
      }
    });
  }

  final Stream<dynamic> _barcodeScanner;
  final OrderRepository _repository;

  Future<void> _shipOrder(
    _ShipmentShipOrderPressed event,
    Emitter<ShipmentState> emit,
  ) async {
    emit(const ShipmentState.inProgress());
    try {
      await _repository.shipOrder(PostOrderModel.fromOrder(event.order));
      emit(const ShipmentState.success());
    } on AppException catch (e) {
      emit(ShipmentState.error(e));
    }
  }

  void _findShipment(
    _ShipmentScanned event,
    Emitter<ShipmentState> emit,
  ) {
    if (state is ShipmentInitial) {
      var barcodeNotFound = true;
      var shipments =
          List<ShipmentModel>.from((state as ShipmentInitial).shipments);
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
      emit(ShipmentState.initial(shipments));
    }
  }
}
