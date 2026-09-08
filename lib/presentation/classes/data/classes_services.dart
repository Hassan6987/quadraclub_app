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
}
