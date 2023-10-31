import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';

part 'shipment_event.dart';
part 'shipment_state.dart';
part 'shipment_bloc.freezed.dart';

class ShipmentBloc extends Bloc<ShipmentEvent, ShipmentState> {
  ShipmentBloc({
    required Stream<dynamic> scannerStream,
    required List<ShipmentModel> shipments,
  })  : _barcodeScanner = scannerStream,
        super(ShipmentState.initial(shipments)) {
    on<_ShipmentScanned>(_findShipment);
    _barcodeScanner.listen((barcodeText) {
      if (barcodeText != null) {
        add(ShipmentEvent.findShipment(barcodeText as String));
      }
    });
  }

  final Stream<dynamic> _barcodeScanner;

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
