import 'package:equatable/equatable.dart';
import 'package:quadraclub_app/presentation/authentication/data/auth_provider.dart'
    show AuthProvider;
import 'package:quadraclub_app/presentation/home/data/scanned_team_model.dart';
import 'package:quadraclub_app/presentation/teams/data/scanned_athlete_events.dart';
import 'package:quadraclub_app/presentation/teams/data/scanned_athlete_timeline.dart';

import '../../../app_exports.dart';
import '../../../di/locator.dart';

part 'teams_event.dart';

part 'teams_state.dart';

class TeamsBloc extends Bloc<TeamsEvent, TeamsState> {
  final AuthProvider _authenticationProvider = locator.get<AuthProvider>();

  TeamsBloc() : super(TeamsState()) {
    on<ScanTeamNFC>(_handleScanNFC);
    on<ScanTeamQR>(_handleScanQR);
    on<FetchAthleteHistory>(_handleFetchAthleteTimeline);
    on<AddPlayerInRoster>(_handleAddToRoster);
  }

  Future<void> _handleScanNFC(
    ScanTeamNFC event,
    Emitter<TeamsState> emit,
  ) async {
    emit(state.copyWith(status: TeamStateStatus.scanning));
    try {
      final scannedTeam = await _authenticationProvider.scanTeamNFC(
        nfcId: event.nfcId,
      );
      emit(
        state.copyWith(
          status: TeamStateStatus.scanned,
          scannedTeam: scannedTeam,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TeamStateStatus.error, error: e.toString()));
    }
  }

  Future<void> _handleScanQR(ScanTeamQR event, Emitter<TeamsState> emit) async {
    emit(state.copyWith(status: TeamStateStatus.scanning));
    try {
      final scannedTeam = await _authenticationProvider.scanTeamQR(
        teamId: event.teamId,
      );
      emit(
        state.copyWith(
          status: TeamStateStatus.received,
          scannedTeam: scannedTeam,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TeamStateStatus.error, error: e.toString()));
    }
  }

  Future<void> _handleAddToRoster(
    AddPlayerInRoster event,
    Emitter<TeamsState> emit,
  ) async {
    try {
      final scannedTeam = state.scannedTeam;
      if (scannedTeam == null) return;

      final updatedAthletes = scannedTeam.athletes.map((athlete) {
        return athlete.id == event.athleteId
            ? athlete.copyWith(inRoster: true)
            : athlete;
      }).toList();

      emit(
        state.copyWith(
          status: TeamStateStatus.success,
          scannedTeam: scannedTeam.copyWith(athletes: updatedAthletes),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TeamStateStatus.error, error: e.toString()));
    }
  }

  Future<void> _handleFetchAthleteTimeline(
    FetchAthleteHistory event,
    Emitter<TeamsState> emit,
  ) async {
    emit(state.copyWith(status: TeamStateStatus.fetching));
    try {
      final history = await Future.wait([
        _authenticationProvider.getEventsHistory(userId: event.athleteId),
        _authenticationProvider.getTimelineMetrics(event.athleteId),
      ]);
      final events = history[0] as List<CompletedEvent>;
      final timeline = history[1] as List<AthleteTimeline>;
      emit(
        state.copyWith(
          status: TeamStateStatus.fetched,
          completedEvents: events,
          timelineMetrics: timeline,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TeamStateStatus.error, error: e.toString()));
    }
  }
}
