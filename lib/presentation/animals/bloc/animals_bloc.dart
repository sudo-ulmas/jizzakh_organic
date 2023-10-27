import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';

part 'animals_event.dart';
part 'animals_state.dart';
part 'animals_bloc.freezed.dart';

class AnimalsBloc extends Bloc<AnimalsEvent, AnimalsState> {
  AnimalsBloc({
    required AnimalRepository animalRepository,
  })  : _repository = animalRepository,
        super(const AnimalsState.initial()) {
    on<_AnimalsLoadRequested>((e, emit) => _getAnimals(emit));
  }

  final AnimalRepository _repository;

  Future<void> _getAnimals(
    Emitter<AnimalsState> emit,
  ) async {
    try {
      emit(const AnimalsState.inProgress());
      final animals = await _repository.getAnimals();
      emit(AnimalsState.success(animals));
    } catch (e) {
      print(e.toString());
      emit(const AnimalsState.error());
    }
  }
}
