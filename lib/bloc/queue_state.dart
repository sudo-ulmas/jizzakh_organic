part of 'queue_bloc.dart';

@freezed
class QueueState with _$QueueState {
  const factory QueueState.empty({
    @Default([]) List<PostDocumentModel> documents,
    @Default([]) List<PostOrderModel> orders,
  }) = QueueEmpty;
  const factory QueueState.uploadProgress({
    @Default([]) List<PostDocumentModel> documents,
    @Default([]) List<PostOrderModel> orders,
  }) = QueueUploadInProgress;
}
