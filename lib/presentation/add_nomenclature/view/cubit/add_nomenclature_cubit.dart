import 'package:bloc/bloc.dart';
import 'package:uboyniy_cex/model/model.dart';

class AddNomenclatureCubit extends Cubit<List<AnimalPartModel>> {
  AddNomenclatureCubit() : super([AnimalPartModel.empty(0)]);

  void addAnimalPart() => state.add(AnimalPartModel.empty(state.length));

  void removeAnimalPart(int index) => state.removeAt(index);
}
