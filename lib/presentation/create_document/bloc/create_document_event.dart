part of 'create_document_bloc.dart';

@freezed
class CreateDocumentEvent with _$CreateDocumentEvent {
  const factory CreateDocumentEvent.create() = _CreateDocumentButtonPressed;
}
