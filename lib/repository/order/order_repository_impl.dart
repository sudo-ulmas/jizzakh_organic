import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/util.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;
  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _dioClient.dio.post<Map<String, dynamic>>(
        ApiUrl.orders,
        data: {},
      );

      if (response.statusCode == 200) {
        final transferOrders = (response.data!['docOrders'] as List)
            .map((e) => TransferOrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
        final salesOrders = (response.data!['docsale'] as List)
            .map((e) => SaleOrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return [...transferOrders, ...salesOrders];
      }
      throw Exception(response.statusCode);
    } catch (e) {
      print(e.toString());
      //TODO: make this beatifull
      rethrow;
    }
  }
}
