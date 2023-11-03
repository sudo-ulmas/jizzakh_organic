part of 'queue_bloc.dart';

@freezed
class QueueEvent with _$QueueEvent {
  const factory QueueEvent.appStarted() = _QueueAppStarted;
  const factory QueueEvent.documentUploadFailed(PostDocumentModel document) =
      _QueueDocumentUploadFailed;
  const factory QueueEvent.orderUploadFailed(PostOrderModel order) =
      _QueueOrderUploadFailed;
}
