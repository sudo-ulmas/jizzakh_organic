part of 'shipment_bloc.dart';

@freezed
class ShipmentState with _$ShipmentState {
  const factory ShipmentState.inProgress() = ShipmentInProgress;

  const factory ShipmentState.error(AppException exception) = ShipmentError;

  const factory ShipmentState.initial(List<ShipmentModel> shipments) =
      ShipmentInitial;

  const factory ShipmentState.success() = ShipmentSuccess;

  const factory ShipmentState.barcodeNotFound(String barcode) =
      ShipmentBarcodeNotFound;
}
