import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';

part 'nomenclatures_event.dart';
part 'nomenclatures_state.dart';
part 'nomenclatures_bloc.freezed.dart';

class NomenclaturesBloc extends Bloc<NomenclaturesEvent, NomenclaturesState> {
  NomenclaturesBloc({
    required AnimalRepository animalRepository,
  })  : _repository = animalRepository,
        super(const NomenclaturesState.initial()) {
    on<_NomenclaturesLoadRequested>((e, emit) => _getNomenclatures(emit));
  }

  final AnimalRepository _repository;

  Future<void> _getNomenclatures(
    Emitter<NomenclaturesState> emit,
  ) async {
    try {
      emit(const NomenclaturesState.inProgress());
      final nomenclatures = await _repository.getNomenclatures();
      emit(NomenclaturesState.success(nomenclatures));
    } catch (e) {
      emit(const NomenclaturesState.error());
    }
  }
}
