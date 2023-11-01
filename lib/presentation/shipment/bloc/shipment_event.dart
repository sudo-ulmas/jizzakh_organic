part of 'shipment_bloc.dart';

@freezed
class ShipmentEvent with _$ShipmentEvent {
  const factory ShipmentEvent.findShipment(String barcodeText) =
      _ShipmentScanned;

  const factory ShipmentEvent.shipOrder({required OrderModel order}) =
      _ShipmentShipOrderPressed;
}
