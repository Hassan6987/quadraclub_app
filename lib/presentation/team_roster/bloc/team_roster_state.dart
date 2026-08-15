part of 'team_roster_bloc.dart';

enum RosterStateStatus {
  initial,
  loading,
  success,
  error,
  fetching,
  fetched,
  deleting,
  deleted,
}

class TeamRosterState extends Equatable {
  final RosterStateStatus status;
  final String? errorMessage;
  final List<TeamRoster> roster;
  final List<AthleteTimeline> timelineMetrics;
  final List<CompletedEvent> completedEvents;

  const TeamRosterState({
    this.status = RosterStateStatus.initial,
    this.errorMessage,
    this.roster = const [],
    this.timelineMetrics = const [],
    this.completedEvents = const [],
  });

  TeamRosterState copyWith({
    RosterStateStatus? status,
    String? errorMessage,
    List<TeamRoster>? roster,
    List<AthleteTimeline>? timelineMetrics,
    List<CompletedEvent>? completedEvents,
  }) {
    return TeamRosterState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      roster: roster ?? this.roster,
      timelineMetrics: timelineMetrics ?? this.timelineMetrics,
      completedEvents: completedEvents ?? this.completedEvents,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    roster,
    timelineMetrics,
    completedEvents,
  ];
}
