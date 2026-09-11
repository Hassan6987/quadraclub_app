import 'package:dio/dio.dart';
import 'package:quadraclub_app/data/base_api_service.dart';

class ClassesServices extends BaseApiProvider {
  Future<Response> getAllClasses() async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/class',
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

  Future<Response> enrollClass({
    required String id,
    required bool isPortfolio,
    String? paymentId,
  }) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/payment/class-checkout',
        data: {
          "classId": id,
          "currency": "usd",
          "usePortfolio": isPortfolio,
          "paymentMethod": "stripe",
          if (!isPortfolio) "paymentMethodId": paymentId,
          "confirmImmediately": true,
        },
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }
}
