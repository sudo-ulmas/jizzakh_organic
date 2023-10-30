part of 'shipment_bloc.dart';

@freezed
class ShipmentState with _$ShipmentState {
  const factory ShipmentState.initial() = ShipmentInitial;

  const factory ShipmentState.inProgress() = ShipmentInProgress;

  const factory ShipmentState.error() = ShipmentError;

  const factory ShipmentState.success(List<ShipmentModel> shipments) =
      ShipmentSuccess;

  const factory ShipmentState.barcodeNotFound(String barcode) =
      ShipmentBarcodeNotFound;
}
