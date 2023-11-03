part of 'queue_bloc.dart';

@freezed
class QueueState with _$QueueState {
  const factory QueueState.empty() = QueueEmpty;
  const factory QueueState.uploadProgress() = QueueUploadInProgress;
}
