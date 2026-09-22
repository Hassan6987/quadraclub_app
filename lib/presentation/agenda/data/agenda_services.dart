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
        endpoint: '/api/agenda/requested-bookings',
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

  Future<Response> getPendingInvitations() async {
    try {
      final response = await request(
        method: HttpMethod.get,
        endpoint: '/api/agenda/invitations',
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
        endpoint: '/api/users/players-list',
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
        data: {"playerIds": playerIds},
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

  Future<Response> leaveMatch(String matchId) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/agenda/matches/$matchId/leave',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> respondToMatchRequest(
    String matchId,
    String playerId,
    String action,
  ) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/agenda/matches/$matchId/requests/$playerId/respond',
        data: {"action": action},
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> cancelMatchRequest(String matchId) async {
    try {
      final response = await request(
        method: HttpMethod.delete,
        endpoint: '/api/agenda/matches/$matchId/request',
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> respondToInvitationFree(
    String matchId,
    String action,
  ) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/agenda/matches/$matchId/invitation/respond',
        data: {"action": action},
      );
      return response;
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> respondToInvitationPaid(
    String matchId,
    bool usePortfolio,
    String paymentId,
    String cardHolderName,
  ) async {
    try {
      final response = await request(
        method: HttpMethod.post,
        endpoint: '/api/agenda/matches/$matchId/invitation/respond',
        data: {
          "action": "accept",
          if (usePortfolio) "usePortfolio": usePortfolio,
          if (!usePortfolio) "paymentMethodId": paymentId,
          if (!usePortfolio) "cardholderName": cardHolderName,
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
