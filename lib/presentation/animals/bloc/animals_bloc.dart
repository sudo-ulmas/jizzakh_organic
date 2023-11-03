import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/util.dart';

part 'animals_event.dart';
part 'animals_state.dart';
part 'animals_bloc.freezed.dart';

class AnimalsBloc extends Bloc<AnimalsEvent, AnimalsState> {
  AnimalsBloc({
    required AnimalRepository animalRepository,
  })  : _repository = animalRepository,
        super(const AnimalsState.initial()) {
    on<_AnimalsLoadRequested>((e, emit) => _getAnimals(emit));
    on<_AnimalsUploaded>(_removeAnimal);

    _repository.uploadedDocumentIds.listen((event) {
      add(AnimalsEvent.uploaded(event));
    });
  }

  final AnimalRepository _repository;

  Future<void> _removeAnimal(
    _AnimalsUploaded event,
    Emitter<AnimalsState> emit,
  ) async {
    if (state is AnimalsSuccess) {
      late int? removeIndex;
      late AnimalModel? removedAnimal;
      final animals = List<AnimalModel>.from((state as AnimalsSuccess).animals);
      animals.removeWhere((element) {
        if (element.id == event.id) {
          removeIndex = animals.indexOf(element);
          removedAnimal = element;
        }
        return element.id == event.id;
      });
      emit(
        AnimalsSuccess(
          animals,
          removeIndex: removeIndex,
          removedAnimal: removedAnimal,
        ),
      );
    }
  }

  Future<void> _getAnimals(
    Emitter<AnimalsState> emit,
  ) async {
    try {
      emit(const AnimalsState.inProgress());
      final animals = await _repository.getAnimals();
      emit(AnimalsState.success(animals));
    } on AppException catch (e) {
      emit(AnimalsState.error(e));
    }
  }
}
