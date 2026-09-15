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

  Future<Response> joinMatchBooking({
    required String id,
    String? message,
    required bool isPortfolio,
    String? paymentId,
    String? cardHolderName,
    required double amount,
  }) async {
    try {
      final response = await request(
        method: HttpMethod.put,
        endpoint: '/api/booking/$id/join',
        data: {
          "currency": "usd",
          if (message != null && message.isNotEmpty) "message": message,
          "usePortfolio": isPortfolio,
          "amountRequested": amount,
          "paymentMethod": isPortfolio ? "portfolio" : "stripe",
          if (!isPortfolio) "paymentMethodId": paymentId,
          if (!isPortfolio) "cardholderName": cardHolderName,
        },
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getUserDetails(String id) async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/users/$id',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }
}
