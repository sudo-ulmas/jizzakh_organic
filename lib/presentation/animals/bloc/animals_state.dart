part of 'animals_bloc.dart';

@freezed
class AnimalsState with _$AnimalsState {
  const factory AnimalsState.initial() = AnimalsInitial;

  const factory AnimalsState.inProgress() = AnimalsInProgress;

  const factory AnimalsState.error() = AnimalsError;

  const factory AnimalsState.success(List<AnimalModel> animals) =
      AnimalsSuccess;
}
