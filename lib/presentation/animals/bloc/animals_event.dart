part of 'animals_bloc.dart';

@freezed
class AnimalsEvent with _$AnimalsEvent {
  const factory AnimalsEvent.loadAnimals() = _AnimalsLoadRequested;
}
