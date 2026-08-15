import 'package:equatable/equatable.dart';
import 'package:quadraclub_app/presentation/authentication/data/auth_provider.dart';
import 'package:quadraclub_app/presentation/team_roster/data/team_roster_model.dart';
import 'package:quadraclub_app/presentation/teams/data/scanned_athlete_events.dart';
import 'package:quadraclub_app/presentation/teams/data/scanned_athlete_timeline.dart';

import '../../../app_exports.dart';
import '../../../di/locator.dart';

part 'team_roster_event.dart';

part 'team_roster_state.dart';

class TeamRosterBloc extends Bloc<TeamRosterEvent, TeamRosterState> {
  final AuthProvider _authenticationProvider = locator.get<AuthProvider>();

  TeamRosterBloc() : super(TeamRosterState()) {
    on<FetchTeamRoster>(_fetchTeamRoster);
    on<AddPlayerToRoster>(_addPlayerToRoster);
    on<RemovePlayerFromRoster>(_removePlayerFromRoster);
    on<FetchTeamRosterDetails>(_fetchRosterDetails);
  }

  Future<void> _fetchTeamRoster(
    FetchTeamRoster event,
    Emitter<TeamRosterState> emit,
  ) async {
    emit(state.copyWith(status: RosterStateStatus.loading));
    try {
      final roster = await _authenticationProvider.getTeamRoster();
      emit(state.copyWith(status: RosterStateStatus.success, roster: roster));
    } catch (e) {
      emit(
        state.copyWith(
          status: RosterStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _addPlayerToRoster(
    AddPlayerToRoster event,
    Emitter<TeamRosterState> emit,
  ) async {
    emit(state.copyWith(status: RosterStateStatus.loading));
    try {
      await _authenticationProvider.addPlayerToRoster(playerId: event.playerId);
      final roster = await _authenticationProvider.getTeamRoster();
      emit(state.copyWith(status: RosterStateStatus.success, roster: roster));
    } catch (e) {
      emit(
        state.copyWith(
          status: RosterStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _removePlayerFromRoster(
    RemovePlayerFromRoster event,
    Emitter<TeamRosterState> emit,
  ) async {
    emit(state.copyWith(status: RosterStateStatus.deleting));
    try {
      await _authenticationProvider.removePlayFromRoster(
        playerId: event.playerId,
      );
      final roster = await _authenticationProvider.getTeamRoster();
      emit(state.copyWith(status: RosterStateStatus.deleted, roster: roster));
    } catch (e) {
      emit(
        state.copyWith(
          status: RosterStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _fetchRosterDetails(
    FetchTeamRosterDetails event,
    Emitter<TeamRosterState> emit,
  ) async {
    emit(state.copyWith(status: RosterStateStatus.fetching));
    try {
      final history = await Future.wait([
        _authenticationProvider.getEventsHistory(userId: event.playerId),
        _authenticationProvider.getTimelineMetrics(event.playerId),
      ]);
      final events = history[0] as List<CompletedEvent>;
      final timeline = history[1] as List<AthleteTimeline>;
      emit(
        state.copyWith(
          status: RosterStateStatus.fetched,
          completedEvents: events,
          timelineMetrics: timeline,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RosterStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
