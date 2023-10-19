import 'package:bloc/bloc.dart';
import 'package:uboyniy_cex/model/model.dart';

class AddNomenclatureCubit extends Cubit<List<AnimalPartModel>> {
  AddNomenclatureCubit() : super([AnimalPartModel.empty(0)]);

  void addAnimalPart() {
    state.add(AnimalPartModel.empty(state.length));
    emit(state);
  }

  void removeAnimalPart(int index) {
    state.removeAt(index);
    emit(state);
  }

  void editNomenclature(NomenclatureModel nomenclature, int index) {
    final newState = List<AnimalPartModel>.from(
      state.map(
        (e) => e.listIndex == index
            ? e.copyWith(nomenclature: nomenclature, count: '')
            : e,
      ),
    );

    emit(newState);
  }

  void editCount(String text, int index) {
    final newState = List<AnimalPartModel>.from(
      state.map(
        (e) => e.listIndex == index ? e.copyWith(count: text) : e,
      ),
    );

    emit(newState);
  }
}
