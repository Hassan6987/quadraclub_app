import 'package:dio/dio.dart';
import 'package:quadraclub_app/data/base_api_service.dart';

class MatchServices extends BaseApiProvider {
  Future<Response> getAllBookings() async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/booking?matchType=Open',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getPortfolioBalance() async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/payment/portfolio',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }
}
