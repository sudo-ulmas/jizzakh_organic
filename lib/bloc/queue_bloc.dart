import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';

part 'queue_event.dart';
part 'queue_state.dart';
part 'queue_bloc.freezed.dart';

class QueueBloc extends Bloc<QueueEvent, QueueState> {
  QueueBloc({
    required OrderRepository orderRepository,
    required AnimalRepository animalRepository,
    required LocalStorageRepository localStorageRepository,
  })  : _orderRepository = orderRepository,
        _animalRepository = animalRepository,
        _localStorageRepository = localStorageRepository,
        super(const QueueEmpty()) {
    on<_QueueAppStarted>((e, emit) => _startQueue(emit));
    on<_QueueDocumentUploadFailed>(_addDocumentToQueue);
    on<_QueueOrderUploadFailed>(_addOrderToQueue);

    _animalRepository.documents.listen((document) {
      add(QueueEvent.documentUploadFailed(document));
    });

    _orderRepository.orders.listen((order) {
      add(QueueEvent.orderUploadFailed(order));
    });
  }

  final OrderRepository _orderRepository;
  final AnimalRepository _animalRepository;
  final LocalStorageRepository _localStorageRepository;

  Future<void> _startQueue(
    Emitter<QueueState> emit,
  ) async {
    final documents = await _localStorageRepository.getAllDocumentsFromQueue();
    final orders = await _localStorageRepository.getAllOrdersFromQueue();
    emit(state.copyWith(documents: documents, orders: orders));
    await _startUpload(emit);
  }

  Future<void> _addOrderToQueue(
    _QueueOrderUploadFailed event,
    Emitter<QueueState> emit,
  ) async {
    await _localStorageRepository.addOrderToQueue(event.order);

    final orders = List<PostOrderModel>.from(state.orders);
    emit(state.copyWith(orders: orders..add(event.order)));
    await _startUpload(emit);
  }

  Future<void> _addDocumentToQueue(
    _QueueDocumentUploadFailed event,
    Emitter<QueueState> emit,
  ) async {
    await _localStorageRepository.addDocumentToQueue(event.document);
    final documents = List<PostDocumentModel>.from(state.documents);
    emit(state.copyWith(documents: documents..add(event.document)));
    await _startUpload(emit);
  }

  Future<void> _startUpload(Emitter<QueueState> emit) async {
    if (state is QueueUploadInProgress) {
      return;
    }
    emit(
      QueueUploadInProgress(documents: state.documents, orders: state.orders),
    );

    while (state is QueueUploadInProgress) {
      final document =
          await _localStorageRepository.getDocumentsHeadFromQueue();
      final order = await _localStorageRepository.getOrdersHeadFromQueue();
      if (order == null && document == null) {
        emit(const QueueEmpty());
        return;
      }
      if (document != null) {
        try {
          await _animalRepository.createDocument(
            document,
            requestFromQueue: true,
          );
          await _localStorageRepository.deleteDocumentHeadFromQueue();
          final documents = List<PostDocumentModel>.from(state.documents);
          emit(state.copyWith(documents: documents));
        } catch (e) {
          await Future<void>.delayed(const Duration(seconds: 10));
        }
      }

      if (order != null) {
        try {
          await _orderRepository.shipOrder(
            order,
            requestFromQueue: true,
          );
          await _localStorageRepository.deleteOrderHeadFromQueue();
          final orders = List<PostOrderModel>.from(state.orders);
          emit(state.copyWith(orders: orders));
        } catch (e) {
          await Future<void>.delayed(const Duration(seconds: 10));
        }
      }
    }
  }
}
