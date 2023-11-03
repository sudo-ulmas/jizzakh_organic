import 'package:uboyniy_cex/model/model.dart';

abstract class LocalStorageRepository {
  Future<void> addDocumentToQueue(PostDocumentModel document);
  Future<PostDocumentModel?> getDocumentsHeadFromQueue();
  Future<void> deleteDocumentHeadFromQueue();

  Future<void> addOrderToQueue(PostOrderModel order);
  Future<PostOrderModel?> getOrdersHeadFromQueue();
  Future<void> deleteOrderHeadFromQueue();
}
