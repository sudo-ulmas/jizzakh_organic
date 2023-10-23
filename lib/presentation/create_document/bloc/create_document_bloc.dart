import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/repository/repository.dart';

part 'create_document_event.dart';
part 'create_document_state.dart';
part 'create_document_bloc.freezed.dart';

class CreateDocumentBloc
    extends Bloc<CreateDocumentEvent, CreateDocumentState> {
  CreateDocumentBloc({
    required AnimalRepository animalRepository,
  })  : _repository = animalRepository,
        super(const CreateDocumentState.initial()) {
    on<_CreateDocumentButtonPressed>((e, emit) => _createDocument(emit));
  }

  final AnimalRepository _repository;

  Future<void> _createDocument(
    Emitter<CreateDocumentState> emit,
  ) async {
    try {
      emit(const CreateDocumentState.inProgress());
      await _repository.createDocument();
      emit(const CreateDocumentState.success());
    } catch (e) {
      emit(const CreateDocumentState.error());
    }
  }
}
