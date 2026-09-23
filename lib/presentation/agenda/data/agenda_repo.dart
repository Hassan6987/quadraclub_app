import 'dart:developer';

import 'package:parsing_util/parsing_util.dart';
import 'package:quadraclub_app/data/stripe-services.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/agenda/data/agenda_services.dart';
import 'package:quadraclub_app/presentation/agenda/data/model/agenda_detail_model.dart';
import 'package:quadraclub_app/presentation/agenda/data/model/agenda_invitation_model.dart';
import 'package:quadraclub_app/presentation/agenda/data/model/agenda_model.dart';
import 'package:quadraclub_app/presentation/agenda/data/model/missing_feedback_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/invite_player_model.dart';

class AgendaRepo {
  final AgendaServices _services = locator.get<AgendaServices>();

  Future<List<AgendaItem>> getConfirmedAgenda() async {
    try {
      final response = await _services.getConfirmedAgenda();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> classesJson = data['agenda'] as List<dynamic>? ?? [];
      return classesJson
          .map((json) => AgendaItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AgendaItem>> getPendingAgenda() async {
    try {
      final response = await _services.getPendingAgenda();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> classesJson =
          data['requested'] as List<dynamic>? ?? [];
      return classesJson
          .map((json) => AgendaItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AgendaItem>> getPastAgenda() async {
    try {
      final response = await _services.getPastAgenda();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> classesJson = data['agenda'] as List<dynamic>? ?? [];
      return classesJson
          .map((json) => AgendaItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<AgendaMatchDetails> getMatchDetails(String id) async {
    try {
      final response = await _services.getMatchDetails(id);
      final data = response.data as Map<String, dynamic>;
      final matchJson = data['match'] as Map<String, dynamic>;
      return AgendaMatchDetails.fromJson(matchJson);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AgendaInvitation>> getPlayerInvitations() async {
    try {
      final response = await _services.getPendingInvitations();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> playersJson =
          data['invitations'] as List<dynamic>? ?? [];
      return playersJson
          .map(
            (json) => AgendaInvitation.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<InvitePlayerModel>> getAllPlayers() async {
    try {
      final response = await _services.getAllPlayers();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> playersJson = data['players'] as List<dynamic>? ?? [];
      return playersJson
          .map(
            (json) => InvitePlayerModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<InvitePlayerModel>> invitePlayers(
    List<String> playerIds,
    String matchId,
  ) async {
    try {
      final response = await _services.invitePlayers(playerIds, matchId);
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> inviteJson = data['invited'] as List<dynamic>? ?? [];
      return inviteJson
          .map(
            (json) => InvitePlayerModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<double> getPortfolioBalance() async {
    try {
      final response = await _services.getPortfolioBalance();
      final data = response.data as Map<String, dynamic>;
      return ParsingUtil.toSafeDouble(data['portfolioBalance']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<InvitePlayerModel>> cancelPlayerInvite(
    String playerId,
    String matchId,
  ) async {
    try {
      await _services.cancelPlayerInvite(playerId, matchId);
      final response = await _services.getMatchInvites(matchId);
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> inviteJson = data['invited'] as List<dynamic>? ?? [];
      return inviteJson
          .map(
            (json) => InvitePlayerModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> leaveMatch(String matchId) async {
    try {
      await _services.leaveMatch(matchId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> respondToMatchRequest(
    String matchId,
    String playerId,
    String action,
  ) async {
    try {
      await _services.respondToMatchRequest(matchId, playerId, action);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelMatchRequest(String matchId) async {
    try {
      await _services.cancelMatchRequest(matchId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> respondToMatchInvitation({
    required String matchId,
    required String action,
    required bool requirePayment,
    required bool usePortfolio,
    String? name,
    String? number,
    String? cvc,
    String? expiry,
  }) async {
    try {
      if (!requirePayment) {
        await _services.respondToInvitationFree(matchId, action);
      } else {
        if (usePortfolio) {
          await _services.respondToInvitationPaid(
            matchId,
            usePortfolio,
            '',
            '',
          );
        } else {
          // Example:
          // "08/28" -> ["08", "28"]
          final expiryParts = expiry!.split('/');
          if (expiryParts.length != 2) {
            throw Exception('Invalid card expiry date');
          }
          final expMonth = int.tryParse(expiryParts[0]);
          final expYearShort = int.tryParse(expiryParts[1]);
          if (expMonth == null || expYearShort == null) {
            throw Exception('Invalid card expiry date');
          }
          // Convert 28 -> 2028
          final expYear = 2000 + expYearShort;

          final paymentMethodId = await StripeServices.createPaymentMethod(
            cardNumber: number!,
            expMonth: expMonth,
            expYear: expYear,
            cvc: cvc!,
            cardholderName: name!,
          );

          if (paymentMethodId == null) {
            throw Exception('Failed to create Stripe PaymentMethod');
          }
          log('Payment Method ID: $paymentMethodId');
          await _services.respondToInvitationPaid(
            matchId,
            usePortfolio,
            paymentMethodId,
            name,
          );
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<MissingFeedbackResponse> getMissingFeedback() async {
    try {
      final response = await _services.getMissingFeedback();
      final data = response.data as Map<String, dynamic>;
      return MissingFeedbackResponse.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> submitMatchFeedback(
    String matchId,
    SubmitMatchFeedbackRequest request,
  ) async {
    try {
      await _services.submitMatchFeedback(matchId, request.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
