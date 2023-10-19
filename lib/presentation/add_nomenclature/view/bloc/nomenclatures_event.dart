part of 'nomenclatures_bloc.dart';

@freezed
class NomenclaturesEvent with _$NomenclaturesEvent {
  const factory NomenclaturesEvent.loadNomenclatures() =
      _NomenclaturesLoadRequested;
}
