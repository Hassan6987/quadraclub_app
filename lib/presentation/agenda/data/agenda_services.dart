import 'package:dio/dio.dart';
import 'package:quadraclub_app/data/base_api_service.dart';

class AgendaServices extends BaseApiProvider {
  Future<Response> getConfirmedAgenda() async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/agenda?tab=confirmed&type=all',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getPendingAgenda() async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/agenda?tab=pending&type=all',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getPastAgenda() async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/agenda?tab=past&type=all',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }
}
