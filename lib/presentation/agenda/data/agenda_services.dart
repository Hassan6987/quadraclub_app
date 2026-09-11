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

  Future<Response> getMatchDetails(String id) async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/agenda/matches/$id',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllPlayers() async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/users/players',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> invitePlayers(List<String> playerIds, String matchId) async {
    try {
      final response = await request(
          method: HttpMethod.post,
          endpoint: '/api/agenda/matches/$matchId/invite',
          data: {
            "playerIds": playerIds
          }
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> cancelPlayerInvite(String playerId, String matchId) async {
    try {
      final response = await request(
        method: HttpMethod.delete,
        endpoint: '/api/agenda/matches/$matchId/invite/$playerId',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getMatchInvites(String matchId) async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/agenda/matches/$matchId/invited',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }
}
