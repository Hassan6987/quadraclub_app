part of 'teams_bloc.dart';

enum TeamStateStatus {
  initial,
  loading,
  success,
  error,
  scanning,
  scanned,
  received,
  fetching,
  fetched,
}

class TeamsState extends Equatable {
  final TeamStateStatus status;
  final String? error;
  final ScannedTeam? scannedTeam;
  final List<AthleteTimeline> timelineMetrics;
  final List<CompletedEvent> completedEvents;

  const TeamsState({
    this.status = TeamStateStatus.initial,
    this.error,
    this.scannedTeam,
    this.timelineMetrics = const [],
    this.completedEvents = const [],
  });

  TeamsState copyWith({
    TeamStateStatus? status,
    String? error,
    ScannedTeam? scannedTeam,
    List<AthleteTimeline>? timelineMetrics,
    List<CompletedEvent>? completedEvents,
  }) {
    return TeamsState(
      status: status ?? this.status,
      error: error ?? this.error,
      scannedTeam: scannedTeam ?? this.scannedTeam,
      timelineMetrics: timelineMetrics ?? this.timelineMetrics,
      completedEvents: completedEvents ?? this.completedEvents,
    );
  }

  @override
  List<Object?> get props => [
    status,
    error,
    scannedTeam,
    timelineMetrics,
    completedEvents,
  ];
}
