import 'package:dio/dio.dart';
import 'package:quadraclub_app/data/base_api_service.dart';

class ChatServices extends BaseApiProvider {
  Future<Response> getChats() async {
    try {
      return await request(method: HttpMethod.get, endpoint: '/api/chat');
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getMessages(String chatId) async {
    try {
      return await request(
        method: HttpMethod.get,
        endpoint: '/api/message/$chatId',
      );
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> sendMessage({
    required String content,
    required String chatId,
    List<dynamic> attachments = const [],
  }) async {
    try {
      return await request(
        method: HttpMethod.post,
        endpoint: '/api/message',
        data: {
          'content': content,
          'chatId': chatId,
          'attachments': attachments,
        },
      );
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> markMessagesSeen(String chatId) async {
    try {
      return await request(
        method: HttpMethod.put,
        endpoint: '/api/message/$chatId/seen',
      );
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }
}
