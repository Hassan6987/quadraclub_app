import 'package:dio/dio.dart';
import 'package:quadraclub_app/data/base_api_service.dart';

class NotificationServices extends BaseApiProvider{
  Future<Response> getAllNotifications() async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/notification',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> markNotificationAsRead(String id) async {
    try {
      final response = await request(
        method: HttpMethod.put,
        endpoint: '/api/notification/$id/read',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteNotification(String id) async {
    try {
      final response = await request(
        method: HttpMethod.delete,
        endpoint: '/api/notification/$id',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }
}