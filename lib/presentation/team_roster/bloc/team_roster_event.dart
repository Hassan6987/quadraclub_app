part of 'team_roster_bloc.dart';

class TeamRosterEvent extends Equatable {
  const TeamRosterEvent();

  @override
  List<Object?> get props => [];
}

class FetchTeamRoster extends TeamRosterEvent {
  const FetchTeamRoster();
}

class AddPlayerToRoster extends TeamRosterEvent {
  final int playerId;

  const AddPlayerToRoster({required this.playerId});
}

class RemovePlayerFromRoster extends TeamRosterEvent {
  final int playerId;

  const RemovePlayerFromRoster({required this.playerId});
}

class FetchTeamRosterDetails extends TeamRosterEvent {
  final int playerId;

  const FetchTeamRosterDetails({required this.playerId});
}
