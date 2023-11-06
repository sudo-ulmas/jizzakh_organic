import 'package:uboyniy_cex/model/model.dart';

abstract class LocalStorageRepository {
  Future<void> addDocumentToQueue(PostDocumentModel document);
  Future<PostDocumentModel?> getDocumentsHeadFromQueue();
  Future<void> deleteDocumentHeadFromQueue();
  Future<List<PostDocumentModel>> getAllDocumentsFromQueue();

  Future<void> addOrderToQueue(PostOrderModel order);
  Future<PostOrderModel?> getOrdersHeadFromQueue();
  Future<void> deleteOrderHeadFromQueue();
  Future<List<PostOrderModel>> getAllOrdersFromQueue();

  Future<void> saveAnimals(List<AnimalModel> animals);
  Future<List<AnimalModel>> getAnimals();

  Future<void> saveOrders(
    (
      List<SaleOrderModel> saleOrders,
      List<TransferOrderModel> transferOrders,
      List<MovementOrderModel> movementOrders,
    ) orders,
  );
  Future<List<OrderModel>> getOrders();
}
