part of 'nomenclatures_bloc.dart';

@freezed
class NomenclaturesState with _$NomenclaturesState {
  const factory NomenclaturesState.initial() = NomenclaturesInitial;

  const factory NomenclaturesState.inProgress() = NomenclaturesInProgress;

  const factory NomenclaturesState.error() = NomenclaturesError;

  const factory NomenclaturesState.success(
    List<NomenclatureModel> nomenclatures,
  ) = NomenclaturesSuccess;
}
