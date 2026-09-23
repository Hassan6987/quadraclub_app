import 'package:dio/dio.dart';
import 'package:quadraclub_app/data/base_api_service.dart';

class ServiceFeesServices extends BaseApiProvider {
  Future<Response> getServiceFees() async {
    try {
      return await request(
        method: HttpMethod.get,
        endpoint: '/api/service-fees',
      );
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }
}
