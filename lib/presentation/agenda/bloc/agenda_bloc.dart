import 'package:equatable/equatable.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/agenda/data/agenda_repo.dart';
import 'package:quadraclub_app/presentation/agenda/data/model/agenda_detail_model.dart';
import 'package:quadraclub_app/presentation/agenda/data/model/agenda_invitation_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/invite_player_model.dart';

part 'agenda_event.dart';
part 'agenda_state.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  final AgendaRepo _repo = locator.get<AgendaRepo>();

  AgendaBloc() : super(AgendaState()) {
    on<GetAllAgenda>(_handleLoadAgenda);
    on<GetMatchDetails>(_handleFetchMatchDetails);
    on<InvitePlayers>(_handleInvitePlayers);
    on<CancelPlayerInvite>(_handleCancelPlayerInvite);
    on<LeaveMatchEvent>(_handleLeaveMatch);
    on<RespondToMatchRequest>(_handleRespondToMatchRequest);
    on<RespondToInvitation>(_handleRespondToInvitation);
    on<CancelJoinRequest>(_handleCancelJoinRequest);
  }

  Future<void> _handleLoadAgenda(
    GetAllAgenda event,
    Emitter<AgendaState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AgendaStateStatus.loading));

      final response = await Future.wait([
        _repo.getConfirmedAgenda(),
        _repo.getPendingAgenda(),
        _repo.getPastAgenda(),
        _repo.getPlayerInvitations(),
        _repo.getAllPlayers(),
      ]);
      final confirmed = response[0] as List<AgendaItem>;
      final pending = response[1] as List<AgendaItem>;
      final past = response[2] as List<AgendaItem>;
      final invitations = response[3] as List<AgendaInvitation>;
      final players = response[4] as List<InvitePlayerModel>;
      emit(
        state.copyWith(
          status: AgendaStateStatus.success,
          confirmedAgenda: confirmed,
          pendingAgenda: pending,
          pastAgenda: past,
          invitations: invitations,
          players: players,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AgendaStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleFetchMatchDetails(
    GetMatchDetails event,
    Emitter<AgendaState> emit,
  ) async {
    try {
      emit(
        state.copyWith(status: AgendaStateStatus.fetching, matchDetails: null),
      );
      final details = await _repo.getMatchDetails(event.id);
      emit(
        state.copyWith(
          status: AgendaStateStatus.success,
          matchDetails: details,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AgendaStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleInvitePlayers(
    InvitePlayers event,
    Emitter<AgendaState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AgendaStateStatus.updating));
      final invites = await _repo.invitePlayers(event.playerIds, event.matchId);
      emit(
        state.copyWith(
          status: AgendaStateStatus.success,
          matchDetails: state.matchDetails!.copyWith(invited: invites),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AgendaStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleCancelPlayerInvite(
    CancelPlayerInvite event,
    Emitter<AgendaState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AgendaStateStatus.updating));
      final invites = await _repo.cancelPlayerInvite(
        event.playerId,
        event.matchId,
      );
      emit(
        state.copyWith(
          status: AgendaStateStatus.success,
          matchDetails: state.matchDetails!.copyWith(invited: invites),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AgendaStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleLeaveMatch(
    LeaveMatchEvent event,
    Emitter<AgendaState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AgendaStateStatus.loading));
      await _repo.leaveMatch(event.matchId);
      add(GetAllAgenda());
    } catch (e) {
      emit(
        state.copyWith(status: AgendaStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleRespondToMatchRequest(RespondToMatchRequest event,
      Emitter<AgendaState> emit,) async {
    try {
      emit(state.copyWith(status: AgendaStateStatus.updating));
      await _repo.respondToMatchRequest(
        event.matchId,
        event.playerId,
        event.action,
      );
      final details = await _repo.getMatchDetails(event.matchId);
      emit(
        state.copyWith(
          status: AgendaStateStatus.success,
          matchDetails: details,
        ),
      );
      add(GetAllAgenda());
    } catch (e) {
      emit(
        state.copyWith(status: AgendaStateStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _handleRespondToInvitation(RespondToInvitation event,
      Emitter<AgendaState> emit,) async {
    try {
      emit(state.copyWith(status: AgendaStateStatus.updating));
      await _repo.respondToMatchInvitation(event.id, event.action);
      final response = await _repo.getPlayerInvitations();
      final confirmed = await _repo.getConfirmedAgenda();
      emit(
        state.copyWith(
            status: AgendaStateStatus.success,
            invitations: response,
            confirmedAgenda: confirmed
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AgendaStateStatus.failure, error: e.toString()),
      );
    }
  }


  Future<void> _handleCancelJoinRequest(CancelJoinRequest event,
      Emitter<AgendaState> emit,) async {
    try {
      emit(state.copyWith(status: AgendaStateStatus.updating));
      await _repo.cancelMatchRequest(event.matchId);
      final response = await _repo.getPendingAgenda();
      emit(
        state.copyWith(
          status: AgendaStateStatus.success,
          pendingAgenda: response,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AgendaStateStatus.failure, error: e.toString()),
      );
    }
  }
}
