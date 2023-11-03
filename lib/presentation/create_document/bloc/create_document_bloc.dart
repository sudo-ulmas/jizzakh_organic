import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/util.dart';

part 'create_document_event.dart';
part 'create_document_state.dart';
part 'create_document_bloc.freezed.dart';

class CreateDocumentBloc
    extends Bloc<CreateDocumentEvent, CreateDocumentState> {
  CreateDocumentBloc({
    required AnimalRepository animalRepository,
  })  : _repository = animalRepository,
        super(const CreateDocumentState.initial()) {
    on<_CreateDocumentButtonPressed>(_createDocument);
  }

  final AnimalRepository _repository;

  Future<void> _createDocument(
    _CreateDocumentButtonPressed event,
    Emitter<CreateDocumentState> emit,
  ) async {
    try {
      emit(const CreateDocumentState.inProgress());
      await _repository.createDocument(
        PostDocumentModel.fromAnimal(event.animal, event.animalParts),
      );
      emit(const CreateDocumentState.success());
    } on AppException catch (e) {
      emit(CreateDocumentState.error(e));
    }
  }
}
