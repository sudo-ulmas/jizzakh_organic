import 'package:bloc/bloc.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/util/util.dart';

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

  bool validate() {
    return state.every((element) {
      final countingStrategy = element.nomenclature.countingStrategy;
      final isNomenclatureEmpty = element.nomenclature.id == '0';
      final isCountValid = countingStrategy == CountingStrategy.weight
          ? element.count.validateWeightKg
          : element.count.validateCount;

      return !isNomenclatureEmpty && isCountValid;
    });
  }
}
