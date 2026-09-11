import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/agenda/data/agenda_services.dart';
import 'package:quadraclub_app/presentation/agenda/data/model/agenda_detail_model.dart';
import 'package:quadraclub_app/presentation/agenda/data/model/agenda_model.dart';
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
      final List<dynamic> classesJson = data['agenda'] as List<dynamic>? ?? [];
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

  Future<List<InvitePlayerModel>> getAllPlayers() async {
    try {
      final response = await _services.getAllPlayers();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> playersJson = data['players'] as List<dynamic>? ?? [];
      return playersJson
          .map((json) =>
          InvitePlayerModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }


  Future<List<InvitePlayerModel>> invitePlayers(List<String> playerIds,
      String matchId) async {
    try {
      final response = await _services.invitePlayers(playerIds, matchId);
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> inviteJson = data['invited'] as List<dynamic>? ?? [];
      return inviteJson
          .map((json) =>
          InvitePlayerModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<InvitePlayerModel>> cancelPlayerInvite(String playerId,
      String matchId) async {
    try {
      await _services.cancelPlayerInvite(playerId, matchId);
      final response = await _services.getMatchInvites(matchId);
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> inviteJson = data['invited'] as List<dynamic>? ?? [];
      return inviteJson
          .map((json) =>
          InvitePlayerModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
