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
      ..registerAdapter(PostOrderModelAdapter())
      ..registerAdapter(AnimalModelAdapter());

    return HiveLocalStorageRepository._();
  }

  static const _documentQueueBox = 'document_queue';
  static const _orderQueueBox = 'order_queue';
  static const _animalsBox = 'animals';

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
  Future<List<PostDocumentModel>> getAllDocumentsFromQueue() async {
    final box = await Hive.openBox<PostDocumentModel>(_documentQueueBox);
    return box.values.toList();
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

  @override
  Future<List<PostOrderModel>> getAllOrdersFromQueue() async {
    final box = await Hive.openBox<PostOrderModel>(_orderQueueBox);
    return box.values.toList();
  }

  @override
  Future<void> saveAnimals(List<AnimalModel> animals) async {
    final box = await Hive.openBox<AnimalModel>(_animalsBox);
    await box.clear();
    await box.addAll(animals);
  }

  @override
  Future<List<AnimalModel>> getAnimals() async {
    final box = await Hive.openBox<AnimalModel>(_animalsBox);
    return box.values.toList();
  }
}
