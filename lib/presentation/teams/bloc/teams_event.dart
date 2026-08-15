part of 'teams_bloc.dart';

class TeamsEvent extends Equatable {
  const TeamsEvent();

  @override
  List<Object?> get props => [];
}

class ScanTeamNFC extends TeamsEvent {
  final String nfcId;

  const ScanTeamNFC({required this.nfcId});

  @override
  List<Object?> get props => [nfcId];
}

class ScanTeamQR extends TeamsEvent {
  final String teamId;

  const ScanTeamQR({required this.teamId});

  @override
  List<Object?> get props => [teamId];
}

class FetchAthleteHistory extends TeamsEvent {
  final int athleteId;

  const FetchAthleteHistory({required this.athleteId});

  @override
  List<Object?> get props => [athleteId];
}

class AddPlayerInRoster extends TeamsEvent {
  final int athleteId;

  const AddPlayerInRoster({required this.athleteId});

  @override
  List<Object?> get props => [athleteId];
}
