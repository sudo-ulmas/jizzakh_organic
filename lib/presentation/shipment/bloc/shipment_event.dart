part of 'shipment_bloc.dart';

@freezed
class ShipmentEvent with _$ShipmentEvent {
  const factory ShipmentEvent.loadShipment() = _ShipmentLoadRequested;
}
