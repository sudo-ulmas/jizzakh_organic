import 'package:hive_flutter/hive_flutter.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/local_storage/local_storage_repository.dart';

class HiveLocalStorageRepository implements LocalStorageRepository {
  HiveLocalStorageRepository._();

  static Future<HiveLocalStorageRepository> init() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(PostProductModelAdapter())
      ..registerAdapter(PostDocumentModelAdapter())
      ..registerAdapter(PostOrderModelAdapter());

    return HiveLocalStorageRepository._();
  }

  static const _documentQueueBox = 'document_queue';
  static const _orderQueueBox = 'order_queue';

  @override
  Future<void> addDocumentToQueue(PostDocumentModel document) async {
    final box = await Hive.openBox<PostDocumentModel>(_documentQueueBox);
    await box.add(document);
  }

  @override
  Future<void> deleteDocumentHeadFromQueue() async {
    final box = await Hive.openBox<PostDocumentModel>(_documentQueueBox);
    await box.deleteAt(0);
  }

  @override
  Future<PostDocumentModel?> getDocumentsHeadFromQueue() async {
    final box = await Hive.openBox<PostDocumentModel>(_documentQueueBox);
    return box.values.firstOrNull;
  }

  @override
  Future<void> addOrderToQueue(PostOrderModel order) async {
    final box = await Hive.openBox<PostOrderModel>(_orderQueueBox);
    await box.add(order);
  }

  @override
  Future<void> deleteOrderHeadFromQueue() async {
    final box = await Hive.openBox<PostOrderModel>(_orderQueueBox);
    await box.deleteAt(0);
  }

  @override
  Future<PostOrderModel?> getOrdersHeadFromQueue() async {
    final box = await Hive.openBox<PostOrderModel>(_orderQueueBox);
    return box.values.firstOrNull;
  }
}
