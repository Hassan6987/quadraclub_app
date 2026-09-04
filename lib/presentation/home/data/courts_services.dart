import 'package:dio/dio.dart';
import 'package:quadraclub_app/data/base_api_service.dart';

class CourtsServices extends BaseApiProvider {
  Future<Response> getAllCourts() async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/clubs/slots',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }
}
