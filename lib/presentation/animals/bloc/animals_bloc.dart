import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/util.dart';

part 'animals_event.dart';
part 'animals_state.dart';
part 'animals_bloc.freezed.dart';

class AnimalsBloc extends Bloc<AnimalsEvent, AnimalsState> {
  AnimalsBloc(
      {required AnimalRepository animalRepository,
      required LocalStorageRepository localStorageRepository})
      : _repository = animalRepository,
        _localStorageRepository = localStorageRepository,
        super(const AnimalsState.initial()) {
    on<_AnimalsLoadRequested>((e, emit) => _getAnimals(emit));
    on<_AnimalsUploaded>(_removeAnimal);

    _subscription = _repository.uploadedDocumentIds.listen((event) {
      add(AnimalsEvent.uploaded(event));
    });
  }

  final AnimalRepository _repository;
  final LocalStorageRepository _localStorageRepository;
  late StreamSubscription<String> _subscription;

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
    late List<AnimalModel> animalsFromLocalDb;
    try {
      emit(const AnimalsState.inProgress());
      animalsFromLocalDb = await _localStorageRepository.getAnimals();
      if (animalsFromLocalDb.isNotEmpty) {
        emit(AnimalsState.success(animalsFromLocalDb));
      }
      final animals = await _repository.getAnimals();
      if (animals.isNotEmpty) {
        emit(AnimalsState.success(animals));
      } else {
        emit(const AnimalsState.empty());
      }
      await _localStorageRepository.saveAnimals(animals);
    } on AppException catch (e) {
      emit(AnimalsState.error(e));
      if (animalsFromLocalDb.isEmpty) {
        emit(const AnimalsState.empty());
      } else {
        emit(AnimalsState.success(animalsFromLocalDb));
      }
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
