import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/model/movement_order_model.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/util.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;
  @override
  Future<List<OrderModel>> getOrders() => BaseApiHanlder.request(() async {
        final response = await _dioClient.dio.post<Map<String, dynamic>>(
          ApiUrl.orders,
          data: {},
        );

        final movementResponse =
            await _dioClient.dio.post<Map<String, dynamic>>(
          ApiUrl.movementOrders,
          data: {},
        );
        final transferOrders = (response.data!['docOrders'] as List)
            .map((e) => TransferOrderModel.fromJson(e as Map<String, dynamic>));
        final salesOrders = (response.data!['docsale'] as List)
            .map((e) => SaleOrderModel.fromJson(e as Map<String, dynamic>));
        final movementOrders = (movementResponse.data!['docTOPFP'] as List)
            .map((e) => MovementOrderModel.fromJson(e as Map<String, dynamic>));

        return [...transferOrders, ...salesOrders, ...movementOrders];
      });

  @override
  Future<void> shipOrder(OrderModel order) => BaseApiHanlder.request(() async {
        await _dioClient.dio.post<Map<String, dynamic>>(
          order.type.url,
          data: {order.type.idKey: order.id},
        );
      });
}
