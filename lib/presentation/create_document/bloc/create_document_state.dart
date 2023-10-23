part of 'create_document_bloc.dart';

@freezed
class CreateDocumentState with _$CreateDocumentState {
  const factory CreateDocumentState.initial() = CreateDocumentInitial;

  const factory CreateDocumentState.inProgress() = CreateDocumentInProgress;

  const factory CreateDocumentState.success() = CreateDocumentSuccess;

  const factory CreateDocumentState.error() = CreateDocumentError;
}
