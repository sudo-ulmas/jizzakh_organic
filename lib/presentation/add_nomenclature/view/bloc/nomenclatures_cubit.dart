import 'package:bloc/bloc.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';

class NomenclatureCubit extends Cubit<List<NomenclatureModel>> {
  NomenclatureCubit({required AuthRepository authRepository})
      : _repository = authRepository,
        super([]) {
    _repository.nomenclatures.listen(showNomenclatures);
  }

  final AuthRepository _repository;

  void showNomenclatures(List<NomenclatureModel> nomenclature) =>
      emit(nomenclature);
}
