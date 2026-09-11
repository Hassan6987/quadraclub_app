import 'package:equatable/equatable.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/agenda/data/agenda_repo.dart';
import 'package:quadraclub_app/presentation/agenda/data/model/agenda_detail_model.dart';
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
  }

  Future<void> _handleLoadAgenda(
    GetAllAgenda event,
    Emitter<AgendaState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AgendaStateStatus.loading));
      final confirmed = await _repo.getConfirmedAgenda();
      final pending = await _repo.getPendingAgenda();
      final past = await _repo.getPastAgenda();
      final players = await _repo.getAllPlayers();
      emit(
        state.copyWith(
          status: AgendaStateStatus.success,
          confirmedAgenda: confirmed,
          pendingAgenda: pending,
          pastAgenda: past,
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
}
